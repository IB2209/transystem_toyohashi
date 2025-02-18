class PlansController < ApplicationController
  # before_actionを使用して、特定のアクションの前に対象の Plan をセットする
  before_action :set_plan, only: [:edit, :update, :show, :destroy]

  # **一覧表示**
  # move_date（移動日）が設定されており、かつ scheduled（予定済みフラグ）が false または nil のデータを取得
  # 移動日を基準に昇順で並び替え、日付ごとにグループ化
  def index
    @plans = Plan.where.not(move_date: nil).where(scheduled: [false, nil]).order(move_date: :asc)
    @grouped_plans_by_date = @plans.group_by { |plan| plan.move_date.to_date }
  end

  # **新規登録フォームを表示**
  # 新しい Plan オブジェクトを作成し、デフォルトで移動日を今日の9時に設定
  def new
    @plan = Plan.new(move_date: DateTime.current.change(hour: 9, min: 0))
  end
  
  # **新規登録処理**
  # フォームから送信されたデータを保存し、成功すれば一覧へリダイレクト
  # 失敗した場合はエラーメッセージを表示し、フォームを再表示
  def create
    @plan = Plan.new(process_params(plan_params))
    
    if @plan.save
      redirect_to plans_path, notice: '伝票が登録されました。'
    else
      flash.now[:alert] = @plan.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end
  
  # **編集フォームを表示**
  # before_action で取得した @plan を使用
  def edit
  end

  # **更新処理**
  # フォームのデータを @plan に適用し、保存が成功すれば一覧へリダイレクト
  # 失敗した場合はエラーメッセージを表示し、フォームを再表示
  # 更新後に `handle_in_out_entry` を呼び出し、入出庫表の連携を処理する
  def update
  if @plan.update(process_params(plan_params))
    redirect_to plans_path, notice: '伝票を更新しました。'
  else
    render :edit, status: :unprocessable_entity
  end
end

  # **詳細ページを表示**
  # before_action で取得した @plan を使用
  def show
  end

  # **削除処理**
  # 対象の Plan を削除し、一覧へリダイレクト
  def destroy
    @plan.destroy
    redirect_to plans_path, notice: '伝票を削除しました。'
  end

  private

  # **対象の Plan を取得**
  # before_action により、`edit`, `update`, `show`, `destroy` の前に実行される
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # **パラメータの許可設定**
  # `params.require(:plan)` により `plan` キーを持つデータのみ許可
  # 許可されたフィールドのみデータが更新・作成される
  def plan_params
  params.require(:plan).permit(
    :model, :chassis_number, :pickup_location, :delivery_location,
    :move_date, :comment, :issue_detail,
    :model_other, :pickup_other, :delivery_other
  )
end


def process_params(params)
  params[:model] = params[:model_other].present? ? params[:model_other] : (params[:model] == "その他" ? nil : params[:model])
  params[:pickup_location] = params[:pickup_other].present? ? params[:pickup_other] : (params[:pickup_location] == "その他" ? nil : params[:pickup_location])
  params[:delivery_location] = params[:delivery_other].present? ? params[:delivery_other] : (params[:delivery_location] == "その他" ? nil : params[:delivery_location])
  
  params.except(:model_other, :pickup_other, :delivery_other) # その他の値を削除
end

  

  # **車体番号の重複チェック**
  # 以下の条件の場合、重複を許可する:
  # - `pickup_location`（引取先） または `delivery_location`（納車先）が `豊橋プール` の場合
  # それ以外では、すでに存在する `chassis_number`（車体番号）のデータがないかをチェック
  def allow_duplicate_chassis?(plan)
    return true if plan.pickup_location == "豊橋プール" || plan.delivery_location == "豊橋プール"

    !Plan.where(chassis_number: plan.chassis_number)
         .where.not(id: plan.id) # 同じ ID のレコードは除外
         .exists?
  end

  # **入出庫表との連携を処理**
  # `plan` の `pickup_location` や `delivery_location` をもとに適切な処理を実行
  def handle_in_out_entry(plan)
    create_in_entry(plan) if plan.delivery_location == "豊橋プール" # 納車先が豊橋プールなら入庫
    create_out_entry(plan) if plan.pickup_location == "豊橋プール" # 引取先が豊橋プールなら出庫
  end

  # **入庫表へのデータ登録**
  # 既存の `chassis_number`（車体番号）があればデータを更新、なければ新規作成
  def create_in_entry(plan)
    in_entry = InEntry.find_or_initialize_by(chassis_number: plan.chassis_number)

    in_entry.assign_attributes(
      plan_id: plan.id,
      entry_date: plan.move_date, # 移動日を入庫日として登録
      model: plan.model,
      driver_name: "未設定", # 運転者は未設定
      pickup_location: plan.pickup_location,
      company_name: "コックス豊橋", # 固定値
      message: plan.comment
    )

    begin
      in_entry.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "入庫表登録エラー: #{e.record.errors.full_messages.join(", ")} - 伝票ID: #{plan.id}"
    end
  end

  # **出庫表へのデータ登録**
  # 既存の `chassis_number`（車体番号）があればデータを更新、なければ新規作成
  def create_out_entry(plan)
    out_entry = OutEntry.find_or_initialize_by(chassis_number: plan.chassis_number)

    out_entry.assign_attributes(
      plan_id: plan.id,
      entry_date: plan.move_date, # 移動日を出庫日として登録
      model: plan.model,
      driver_name: "未設定", # 運転者は未設定
      delivery_location: plan.delivery_location,
      pickup_location: plan.pickup_location,
      message: plan.comment
    )

    begin
      out_entry.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "出庫表登録エラー: #{e.record.errors.full_messages.join(", ")} - 伝票ID: #{plan.id}"
    end
  end
end

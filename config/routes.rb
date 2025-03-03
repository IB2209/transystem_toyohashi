Rails.application.routes.draw do
  # movement-records.onrender.com にアクセスした場合は Cox Gear にリダイレクト
  constraints(lambda { |req| req.host == "movement-records.onrender.com" }) do
    get "/", to: redirect("https://www.cox-gear.jp/")
  end

  # それ以外のドメインでは入庫一覧を表示
  root "entries#index"
  # スマートフォン用
  get "smartphone", to: "smartphone#index"

  # 日報関連
  resources :daily_reports, only: [:index, :new, :create] do
    collection do
      get :fetch_records # ✅ 追加
    end
  end

  # スケジュール関連
  resources :schedules

  # 移動記録関連
  resources :movement_records do
    member do
      patch :toggle_status_1
      patch :toggle_status_2
      get :report  # 個別の日報表示ページ
      post :print  # 印刷処理
    end
  end

  # 入庫情報
  resources :in_entries do
    collection do
      post :confirm
      get :success # 送信完了ページ
    end
  end

  # 出庫情報
  resources :out_entries

  # 伝票関連
  resources :plans do
    collection do
      get :scheduled
    end
  end

  # 入庫・出庫データ関連
  resources :entries, except: [:show] do
    collection do
      get :unshipped # 未出庫データ用のルート
    end
  end
  
end

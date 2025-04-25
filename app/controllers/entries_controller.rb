class EntriesController < ApplicationController
  def index
    # **🔥 `includes(:out_entry)` を利用してクエリの最適化**
    @in_entries = InEntry.includes(:movement_record, out_entries: :movement_record)
                     .order(entry_date: :desc, id: :desc)


    # **🔥 `in_entry_id` を使って、正しい出庫データを取得**
   # 🚀 `entry_date` に基づいて対応する `OutEntry` を取得
    @entries = @in_entries.map do |in_entry|
      out_entry = in_entry.out_entries.where("entry_date >= ?", in_entry.entry_date).order(entry_date: :asc).first

      {
        in_entry: in_entry,
        out_entry: out_entry,
        stay_days: out_entry ? (out_entry.entry_date - in_entry.entry_date).to_i : nil
      }
    end
    
    
    
    

    # 月ごとの入庫台数と出庫台数を計算
    @grouped_entries_by_month = @entries.group_by { |entry| entry[:in_entry].entry_date.beginning_of_month }
    @monthly_counts = @grouped_entries_by_month.transform_values do |entries|
      {
        in_count: entries.size, # 入庫データの件数
        out_count: entries.count { |entry| entry[:out_entry].present? } # 出庫データが存在する件数
      }
    end
  end

  def unshipped
    # 🔥 `in_entry_id: nil` を使用して未出庫の入庫データを取得
    @in_entries = InEntry.left_joins(:out_entries)
                     .where(out_entries: { id: nil })
                     .order(:model, :chassis_number)


    # @in_entries が空でも @grouped_entries は空のハッシュとして扱えるようにする
    @grouped_entries = @in_entries.group_by(&:model) || {}
  end
end

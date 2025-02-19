class EntriesController < ApplicationController
  def index
    # 入庫データと関連する出庫データを一括取得し、入庫データを最新順（降順）にソート
    @in_entries = InEntry.includes(:out_entry).order(entry_date: :desc, id: :desc)

    # 入庫データと対応する出庫データを結合し、車泊数を計算
    @entries = @in_entries.map do |in_entry|
      {
        in_entry: in_entry,
        out_entry: in_entry.out_entry,
        stay_days: in_entry.out_entry ? (in_entry.out_entry.entry_date - in_entry.entry_date).to_i : nil
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
    # 未出庫の入庫データを取得し、型式でグループ化
    @in_entries = InEntry.includes(:out_entry).where(out_entries: { id: nil }).order(:model, :chassis_number)
  
    # @in_entries が空でも @grouped_entries は空のハッシュとして扱えるようにする
    @grouped_entries = @in_entries.group_by(&:model) || {}
  end
  
end

Rails.application.routes.draw do
  # 指定のドメインでアクセスされた場合、リダイレクト
  constraints(lambda { |req| req.host == "movement-records.onrender.com" }) do
    get "/", to: redirect("https://www.cox-gear.jp/")
    #get "/in_entries", to: redirect("https://www.cox-gear.jp/")
    #get "/entries", to: redirect("https://www.cox-gear.jp/")
    #get "/out_entries", to: redirect("https://www.cox-gear.jp/")
  end

  # 通常のルート設定
  root "entries#index"
  #get "/in_entries", to: "in_entries#index"
  #get "/entries", to: "entries#index"
  #get "/out_entries", to: "out_entries#index"
  
  # スマートフォン用
  get "smartphone", to: "smartphone#index"

  # 日報関連
  resources :daily_reports do
    collection do
      get :fetch_records # ✅ 追加
    end
  end

  # スケジュール関連
  resources :schedules do
    member do
      patch :depart
      patch :arrive
    end
  end

  
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
  resources :out_entries do
    collection do
      post :confirm  # 確認画面
      get :success   # 登録完了画面
    end
  end

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

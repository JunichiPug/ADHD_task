Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root "routines#index"

  # 💡 変更点: resources :routines をブロック形式にして、start アクションを組み込みます
  resources :routines do
    get :start, on: :member
  end

  # メモ帳（買い物・覚書きリスト）
  resources :memos, only: %i[index create update destroy] do
    collection do
      delete :destroy_completed
      delete :destroy_all
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

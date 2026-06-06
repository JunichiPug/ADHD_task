Rails.application.routes.draw do
  devise_for :users

  root "routines#index"

  # 💡 変更点: resources :routines をブロック形式にして、start アクションを組み込みます
  resources :routines do
    get :start, on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end

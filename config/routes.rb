Rails.application.routes.draw do

  devise_for :users
  root to: 'home#home'
  get 'blob', to: 'flyers#blob'
  get 'flyer/:id/image/:size', to: 'flyers#image'
  get 'jpg_passthrough', to: 'flyers#jpg_passthrough'
  
  concern :actionable do 
    resources :user_actions
  end
  
  resources :push_notifications
  resources :user_actions
  resources :users, :actionable
  resources :flyers, concerns: :actionable do 
    member do
      get 'blob'
      get 'delete'
    end
  end
end
  
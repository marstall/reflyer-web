Rails.application.routes.draw do

  resources :push_notifications
  root to: 'home#home'
  get 'blob', to: 'flyers#blob'
  
  concern :actionable do 
    resources :user_actions
  end
  
  resources :user_actions
  resources :users, :actionable
  resources :flyers, concerns: :actionable do 
    member do
      get 'blob'
      get 'delete'
    end
  end
end
  
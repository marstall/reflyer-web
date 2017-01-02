Rails.application.routes.draw do |map|
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get '/', to: 'home#home'
    get '/flyer/:id', to: 'flyers#flyer'
    post '/flyers', to: 'flyers#create'
    get '/flyers', to: 'flyers#flyers'
    
    match ':controller/:action/:id', via: [:get, :post]
    match ':controller/:action', via: [:get, :post]
end

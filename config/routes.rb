Rails.application.routes.draw do
 
  post 'city/create'
  get 'city/view/:id', to: 'city#view'
  get 'city/show', to: 'city#show'
  get 'city/delete/:id', to: 'city#delete'
  post 'city/update/:id', to: 'city#update'

  get 'vehicle/create'
  post 'vehicle/create'
  get 'vehicle/view/:id', to: 'vehicle#view'
  get 'vehicle/show', to: 'vehicle#show'
  get 'vehicle/delete/:id', to: 'vehicle#delete'
  get 'vehicle/update/:id', to: 'vehicle#update'
  post 'vehicle/update/:id', to: 'vehicle#update'

  post 'trip/create'
  get 'trip/view/:id', to: 'trip#view'
  get 'trip/show', to: 'trip#show'
  get 'trip/delete/:id', to: 'trip#delete'
  post 'trip/update/:id', to: 'trip#update'

  get 'welcome/index'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

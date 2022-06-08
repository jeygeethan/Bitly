Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope as: :urls do
    get 'urls' => 'urls#show', as: :show
    post 'urls' => 'urls#create', as: :create
  end

  get '/:slug' => 'root#index', as: :root_router
  root to: 'root#index'
end

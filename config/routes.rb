Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope as: :urls do
    get 'urls' => 'urls#show', as: :show
    post 'urls' => 'urls#create', as: :create
  end
end

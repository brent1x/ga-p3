Rails.application.routes.draw do
  root 'users#login'

  get 'login', to: "users#login", as: 'login'
  post 'login', to: "users#attempt_login", as: 'attempt_login'

  get 'signup', to: "users#signup", as: 'signup'
  post 'signup', to: "users#create", as: 'create'

  delete 'logout', to: "users#logout", as: "logout"

  get 'about', to: "sites#about", as: 'about'
  get 'menu', to: "sites#menu", as: 'menu'

  get 'home', to: "users#home", as: 'home'
  get 'account', to: "users#account", as: 'account'

  get 'add', to: "sites#add", as: 'add'
  post 'add', to: "sites#add", as: 'add_restuarant'
end

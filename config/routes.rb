Rails.application.routes.draw do

  get 'users/login'

  get 'users/signup'

  get 'users/account'

  root 'users#login'
  get 'login', to: "users#login", as: 'login'
  post 'login', to: "users#attempt_login"

  get 'signup', to: "users#signup", as: 'signup'
  post 'signup', to: "users#create"

  delete 'logout', to: "users#logout", as: "logout"

  get 'about', to: "site#about", as: 'about'
  get 'menu', to: "site#menu", as: 'menu'

  get 'home'

end

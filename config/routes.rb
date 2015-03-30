Rails.application.routes.draw do


  root 'users#login'

  resources :queues

  get 'login', to: "users#login", as: 'login'
  post 'login', to: "users#attempt_login",as: 'attempt_login'

  get 'signup', to: "users#signup", as: 'signup'
  post 'signup', to: "users#create", as: 'create'

  delete 'logout', to: "users#logout", as: "logout"

  get 'about', to: "sites#about", as: 'about'
  get 'menu', to: "sites#menu", as: 'menu'

  get 'home', to: "users#home", as: 'home'
  get 'account', to: "users#account", as: 'account'

  get 'add', to: "sites#add", as: 'add'
  post 'add', to: "sites#add", as: 'add_restuarant'

  


###################### RAKE ROUTES PASTED BELOW ######################
#                                                                    #
#      Prefix Verb   URI Pattern                Controller#Action    #
#        root GET    /                          users#login          #
#      queues GET    /queues(.:format)          queues#index         #
#             POST   /queues(.:format)          queues#create        #
#   new_queue GET    /queues/new(.:format)      queues#new           #
#  edit_queue GET    /queues/:id/edit(.:format) queues#edit          #
#       queue GET    /queues/:id(.:format)      queues#show          #
#             PATCH  /queues/:id(.:format)      queues#update        #
#             PUT    /queues/:id(.:format)      queues#update        #
#             DELETE /queues/:id(.:format)      queues#destroy       #
#       login GET    /login(.:format)           users#login          #
#             POST   /login(.:format)           users#attempt_login  #
#      signup GET    /signup(.:format)          users#signup         #
#             POST   /signup(.:format)          users#create         #
#      logout DELETE /logout(.:format)          users#logout         #
#       about GET    /about(.:format)           sites#about          #
#        menu GET    /menu(.:format)            sites#menu           #
#        home GET    /home(.:format)            users#home           #
#     account GET    /account(.:format)         users#account        #
#                                                                    #
######################################################################
end

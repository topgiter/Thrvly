Prelaunchr::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#new"

  resources :users do
    collection do
      get :faq
      get :jobs
      get :partner
      get :policy
      get :presskit
      get :terms
    end
  end

  match 'refer-a-student' => 'users#refer_student'
  match 'refer-a-instructor' => 'users#refer_instructor'

  match 'student' => 'public#student'
  match 'instructor' => 'public#instructor'
  
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  # unless Rails.application.config.consider_all_requests_local
  #     match '*not_found', to: 'users#redirect', :format => false
  # end
end

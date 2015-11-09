Prelaunchr::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#new"

  match 'users/create' => 'users#create'

  match 'refer-a-friend' => 'users#refer'

  match 'privacy-policy' => 'users#policy'
  match 'faq' => 'users#faq'
  match 'jobs' => 'users#jobs'
  match 'partner' => 'users#partner'
  match 'policy' => 'users#policy'
  match 'presskit' => 'users#presskit'
  match 'terms' => 'users#terms'
  
  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  unless Rails.application.config.consider_all_requests_local
      match '*not_found', to: 'users#redirect', :format => false
  end
  
  match 'venues/faq', :to => 'venues#faq'
  match 'venues/index', :to => 'venues#index'
end

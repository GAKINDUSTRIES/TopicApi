Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations:  'api/v1/registrations',
    sessions:  'api/v1/sessions',
    passwords:  'api/v1/passwords'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      devise_scope :user do
        get :status, to: 'api#status'
        resources :topics, only: :index
        resources :targets, only: %i(create index destroy)
        resources :match_conversations, only: :index do
          get :messages
        end
        resources :messages, only: :index
        resources :users, only: %i(show update) do
          controller :sessions do
            post :facebook, on: :collection
          end
        end

        resources :questions, only: :create
      end
      mount ActionCable.server => '/cable'
    end
  end
end

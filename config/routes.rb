
Rails.application.routes.draw do
  devise_for :users
  root to: 'moons#main'
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end

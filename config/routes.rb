Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :webhooks do
    post "/pull_request", to: "webhooks#pull_request"
  end
end

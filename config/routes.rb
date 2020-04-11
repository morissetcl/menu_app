# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # sidekiq monitoring
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, 'sidekiq') &
        ActiveSupport::SecurityUtils.secure_compare(password, 'sidekiq')
  end
  mount Sidekiq::Web, at: "/sidekiq"
end

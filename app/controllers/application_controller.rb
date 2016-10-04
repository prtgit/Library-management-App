class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  config.time_zone = 'Eastern Time (US & Canada)'
end

class AuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  if Rails::VERSION::MAJOR < 4
    before_filter :authenticate!
  else
    before_action :authenticate!
  end

  def index
    if Rails::VERSION::MAJOR < 4
      render text: 'zuper content', status: 200
    else
      render plain: 'zuper content', status: 200
    end
  end

end

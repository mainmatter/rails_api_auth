class AccessOnceController < ApplicationController

  include RailsApiAuth::Authentication

  if Rails::VERSION::MAJOR < 4
    before_filter :consume_single_use_oauth2_token!
  else
    before_action :consume_single_use_oauth2_token!
  end

  def index
    if Rails::VERSION::MAJOR < 4
      render text: 'zuper content', status: :ok
    else
      render plain: 'zuper content', status: :ok
    end
  end

end

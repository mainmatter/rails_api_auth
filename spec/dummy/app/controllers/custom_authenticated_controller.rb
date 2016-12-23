class CustomAuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  if Rails::VERSION::MAJOR < 4
    before_filter :authenticate_with_account!
  else
    before_action :authenticate_with_account!
  end

  def index
    if Rails::VERSION::MAJOR < 4
      render text: 'zuper content', status: 200
    else
      render plain: 'zuper content', status: 200
    end
  end

  private

    def authenticate_with_account!
      authenticate! do
        current_login.account.first_name == 'user x'
      end
    end

end

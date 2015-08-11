require 'rails_api_auth/authentication'

class CustomAuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  before_filter :authenticate_with_account!

  def index
    render text: 'zuper content', status: 200
  end

  private

    def authenticate_with_account!
      authenticate! do
        current_login.account.first_name == 'user x'
      end
    end

end

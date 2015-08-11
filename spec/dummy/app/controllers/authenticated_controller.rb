require 'rails_api_auth/authentication'

class AuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  before_filter :authenticate!

  def index
    render text: 'zuper content', status: 200
  end

end

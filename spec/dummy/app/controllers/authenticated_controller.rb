require 'rails_api_auth/authentication'

class AuthenticatedController < ApplicationController

  include RailsApiAuth::Authentication

  before_action :authenticate!

  def index
    render text: 'zuper content'
  end

end

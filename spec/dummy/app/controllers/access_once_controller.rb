class AccessOnceController < ApplicationController

  include RailsApiAuth::Authentication

  before_filter :consume_single_use_oauth2_token!

  def index
    render text: 'zuper content', status: 200
  end

end

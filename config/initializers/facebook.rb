Rails.application.config.x.facebook.tap do |facebook|
  facebook.app_id       = ENV['FB_APP_ID']
  facebook.app_secret   = ENV['FB_APP_SECRET']
  facebook.graph_url    = 'https://graph.facebook.com/v2.3'
  facebook.redirect_uri = 'http://localhost:4200/login'
end

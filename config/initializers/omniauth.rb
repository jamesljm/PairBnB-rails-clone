# In config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_KEY'], ENV['FACEBOOK_APP_SECRET'], scope: 'email', info_fields: 'email, first_name, last_name, gender, birthday'
end
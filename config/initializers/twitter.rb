require 'yaml'

credentials = YAML::load(File.open(Rails.root.join('config', 'credentials.yml')))
Twitter.configure do |config|
  config.consumer_key = credentials['TWITTER_CONSUMER_KEY']
  config.consumer_secret = credentials['TWITTER_CONSUMER_SECRET']
  config.oauth_token = credentials['TWITTER_OAUTH_ACCESS_TOKEN']
  config.oauth_token_secret = credentials['TWITTER_OAUTH_ACCESS_TOKEN_SECRET']
end

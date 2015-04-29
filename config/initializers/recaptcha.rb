Recaptcha.configure do |config|
  config.public_key  = ENV['RECAPTCHA_PUBLIC_KEY']
  config.private_key = ENV['RECAPTCHA_PRIVATE_KEY']
	# config.proxy = 'http://myproxy.com:8080'
  # >= version 0.3.7 can use newer API
  config.api_version = 'v2'
end
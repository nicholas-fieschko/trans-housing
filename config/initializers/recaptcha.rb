Recaptcha.configure do |c|
	c.public_key:  ENV['RECAPTCHA_PUBLIC_KEY']
	c.private_key: ENV['RECAPTCHA_PRIVATE_KEY']
	c.api_version: 'v2'
end

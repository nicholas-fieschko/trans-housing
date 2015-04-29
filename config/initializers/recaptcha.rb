<<<<<<< HEAD
Recaptcha.configure do |c|
	c.public_key  = ENV['RECAPTCHA_PUBLIC_KEY']
	c.private_key = ENV['RECAPTCHA_PRIVATE_KEY']
	c.api_version = 'v2'
=======
Recaptcha.configure do |config|
  config.public_key  = '6Ld1TwUTAAAAAOgV0Vm8UIT7zn-kEiF-Sa3gX6gK'
  config.private_key = '6Ld1TwUTAAAAAD2mUqF3B-n35QsxoUEd1UPJsAte'
	# config.proxy = 'http://myproxy.com:8080'
  # >= version 0.3.7 can use newer API
  config.api_version = 'v2'
>>>>>>> c22a58b90cb2d2d5d0f1957582bcf9a1d81e0062
end

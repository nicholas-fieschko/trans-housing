Recaptcha.configure do |config|
  config.public_key  = '6Ld1TwUTAAAAAOgV0Vm8UIT7zn-kEiF-Sa3gX6gK'
  config.private_key = '6Ld1TwUTAAAAAD2mUqF3B-n35QsxoUEd1UPJsAte'
	# config.proxy = 'http://myproxy.com:8080'
  # >= version 0.3.7 can use newer API
  config.api_version = 'v2'
end

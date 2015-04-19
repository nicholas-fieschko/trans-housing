require 'twilio-ruby'

class TwilioController < ApplicationController
	include Webhookable

	# 'set_header' and 'render_twiml' abstracted to concerns/webhookable.rb	
	after_filter :set_header
	
	# Disable CSRF Detections
	skip_before_action :verify_authenticity_token

	# Respond to incoming text messages; "Message" verb is for SMS
	def sms
		response = Twilio::TwiML::Response.new do |job|
			job.Message "Hi, just texting you back."
		end
		render_twiml response
	end

end

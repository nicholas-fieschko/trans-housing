require 'twilio-ruby'

class TwilioController < ApplicationController
	include Webhookable

	# N.B.: 'set_header', 'render_twiml' in concerns/webhookable.rb	
	after_filter :set_header
	
	# Disable CSRF Detections
	skip_before_action :verify_authenticity_token

	# Respond to incoming text messages; "Message" verb is for SMS
	# - linked to route in routes.rb
	def sms
		in_from  = params[:From]
		in_state = params[:FromState]
		response = Twilio::TwiML::Response.new do |job|
			job.Message "Hi, just texting you back, #{in_from}, (#{in_state})"
		end
		render_twiml response
	end

end
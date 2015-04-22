class Conversation
  include Mongoid::Document
	include Mongoid::Timestamps::Updated
	
	# 'Creation' isn't relevant for sorting; use the most recent message time
	# as the update field for the conversation
	default_scope -> { order(updated_at: :desc) }

	# Fields
	field :updated_at, type: Time, default: Time.now	
	field :subject, type: String

	# Relations
	has_and_belongs_to_many :users
	has_many :messages

	# Validations
	#validates_length_of :subject, minimum: 1, maximum: 300

	# Methods
	def test
	end

	# TODO will Mongoid know that a message added is an update?


end

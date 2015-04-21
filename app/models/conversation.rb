class Conversation
  include Mongoid::Document
	include Mongoid::Timestamps::Updated
	
	# 'Creation' isn't relevant for sorting; use the most recent message time
	# as the update field for the conversation
	default_scope -> { order(updated_at: :desc) }

	# Fields
	field :updated_at, type: Time, default: Time.now	

	# Relations
	has_and_belongs_to_many :users
	has_many :messages

	# Methods
	def test
	end

	# TODO will Mongoid know that a message added is an update?


end

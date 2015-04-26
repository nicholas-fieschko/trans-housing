class Message
  include Mongoid::Document
	include Mongoid::Timestamps::Created

	# Return in descending order (:asc?)
	default_scope -> { order(created_at: :desc) }

	# Fields (sender/receiver are user_ids)
	field :created_at, type: Time, default: Time.now
	field :text, type: String

	# Relations. Sender is a relation since we may want to grab all a user's
	# messages--that sort of thing.
	belongs_to :conversation
	belongs_to :sender, class_name: 'User'

	# Error-checking
	validates_length_of :text, minimum: 1, maximum: 1000
end
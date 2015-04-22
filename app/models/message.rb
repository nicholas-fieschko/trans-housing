class Message
  include Mongoid::Document
	include Mongoid::Timestamps::Created

	# Return in descending order (:asc?)
	default_scope -> { order(created_at: :desc) }

	# Fields (sender/receiver are user_ids)
	field :created_at, type: Time, default: Time.now
	field :text, type: String
	field :sender
	field :receiver

	# Relations
	belongs_to :conversation
	
	# Error-checking
	validates_length_of :text, minimum: 1, maximum: 1000

	# TODO

end

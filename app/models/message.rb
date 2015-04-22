class Message
  include Mongoid::Document

	# Fields
	field :created, type: DateTime, default: -> { Time.now }
	field :text, type: String

	# Relations
	belongs_to :conversation
	field :sender
	field :receiver

	# TODO

end

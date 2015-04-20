class Message
  include Mongoid::Document

	# Fields
	field :created, type: DateTime, default: -> { Time.now }
	field :text, type: String

	# Relations
	belongs_to :conversation
	has_one :sender, :class_name => 'User'
	has_one :receiver, :class_name => 'User'

	# TODO

end

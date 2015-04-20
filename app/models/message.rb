class Message
  include Mongoid::Document

	# Extremely basic fields. Just keep it to text.
  field :created, type: DateTime, default: -> { Time.now }
  field :content, type: String

	# Relationship is 'has_many' in User model
	belongs_to :sender,   :class_name => 'User', :inverse_of => :messages_sent
	belongs_to :receiver, :class_name => 'User', :inverse_of => :messages_received

	# Some basic validations
  validates_length_of 	:content, minimum: 1, maximum: 1000
  validates_presence_of :sender
	validates_presence_of	:receiver

	# Save a message and give it an ID
	def add_message(user, contact, text)
	end

	# Most basically, the model should grab a specific 1-1 conversation
	def get_convo(user, contact)
		inbound  = user.messages_received.where(:sender => contact)
		outbound = user.messages_sent.where(:receiver => contact)
	end

	# Display all conversations ordered by most recent message
	def get_inbox(user)
	end

	# TODO
	# - Add trash
	# - Add undelete
	# - Add > 2 person conversations
	# - Contribute to MongoID fork for mailboxer

end

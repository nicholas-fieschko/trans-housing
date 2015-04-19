# Code borrowed from StackOverflow discussion by user CarelZA

require 'digest/sha1'

class Conversation
  include Mongoid::Document

  field :lookup_hash, type: String
  field :created, type: DateTime, default: -> { Time.now }
  field :last_message_time, type: DateTime, default: -> { Time.now }
  
	# I think we can just junk this . . . 
	# Array of user ids of users that have read all messages in this conversation
  # field :last_message_seen_by, type: Array, default: []

	# Relationships
  embeds_many :messages
  has_and_belongs_to_many :participants, :class_name => 'User'

  validates_presence_of :lookup_hash

  index({ lookup_hash: 1 }, { unique: true, name: "lookup_hash_index" })
  # Used to show a user a list of conversations ordered by last_message_time
  index(
        { _id: 1, last_message_time: -1 },
        { unique: true, name: "id_last_message_time_index" }
       )

  # Constructs the conversation
  def self.add_message(recipient, sender, message)
    # Find or create a conversation:
    conversation = Conversation.find_or_create_by(
      :lookup_hash => get_lookup_hash([recipient.id, sender.id])) do |c|
        c.participants.concat [recipient, sender]
      end
    conversation.messages << message
    conversation.last_message_time = Time.now
    #conversation.last_message_seen_by.delete(recipient)
    conversation.save
  end

  # Assign the unique group convo a hash by combining all the participant IDs
  private
    def self.get_lookup_hash(participant_ids)
      lookup_key = participant_ids.sort.join(':')
      Digest::SHA1.hexdigest lookup_key
    end

end

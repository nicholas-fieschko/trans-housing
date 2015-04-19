class Message
  include Mongoid::Document

  field :created, type: DateTime, default: -> { Time.now }
  field :text, type: String

  embedded_in :conversation
  belongs_to :author, :class_name => 'User'

  validates_length_of :text, minimum: 2, maximum: 256
  validates_presence_of :author

end

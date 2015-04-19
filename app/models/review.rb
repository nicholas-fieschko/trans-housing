class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  field :authorID, type: BSON::ObjectId
  index({ authorID: 1 }, { name: "authorID_index" })

  field :author, type: String
  field :text, type: String
  field :rating, type: Integer

  field :completed, type: Boolean
  

  # Special date/time field to base expirations on.
  field :expirable_created_at, type: Time

  # TTL index on the above field. Need to run  rake db:mongoid:create_indexes
  index({expirable_created_at: 1}, {expire_after_seconds: 1.month})

  # Callback to set `expirable_created_at`
  before_create :set_expire
  def set_expire
	self.expirable_created_at = Time.now
	self.completed = false
	return true
  end


end

class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  field :recipient_id, type: BSON::ObjectId
  field :reviewer_id, type: BSON::ObjectId
  index({ reviewer_id: 1 }, { name: "reviewer_id_index" })

  field :text, type: String
  field :rating, type: Integer

  field :completed, type: Boolean
  

  # Special date/time field to base expirations on.
  field :expirable_created_at, type: Time

  # TTL index on the above field. Need to run  rake db:mongoid:create_indexes
  index({expirable_created_at: 1}, {expire_after_seconds: 1.month})


  validates_presence_of :text, :rating
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6}

  # Callback to set `expirable_created_at`
  before_create :set_expire
  def set_expire
    self.expirable_created_at = Time.now
    self.completed = false
    return true
  end


  def reviewer
    User.find(self.reviewer_id)
  end

  def recipient
    User.find(self.recipient_id)
  end

  def set_complete
    self.update_attribute(:completed, 1)
    self.update_attribute(:expirable_created_at, nil)
  end

end

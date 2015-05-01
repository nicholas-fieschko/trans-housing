class Exchange
  include Mongoid::Document
  include Mongoid::Timestamps

  default_scope -> { order(created_at: :desc) }

  has_and_belongs_to_many :users

  field :provider_id, type: BSON::ObjectId
  field :seeker_id, type: BSON::ObjectId

  field :seeker_accept_exchange, type: Boolean
  field :provider_accept_exchange, type: Boolean  
  field :seeker_confirm_interaction, type: Boolean
  field :provider_confirm_interaction, type: Boolean

  field :provider_review_for_seeker_id, type: BSON::ObjectId
  field :seeker_review_for_provider_id, type: BSON::ObjectId

  field :completed, type: Boolean


  # Special date/time field to base expirations on.
  field :expirable_created_at, type: Time

  # TTL index on the above field. Need to run  rake db:mongoid:create_indexes
  index({expirable_created_at: 1}, {expire_after_seconds: 1.month})


  before_create :initialization
  def initialization
  	self.expirable_created_at = Time.now
  	self.seeker_accept_exchange = false
  	self.provider_accept_exchange = false
  	self.seeker_confirm_interaction = false
  	self.provider_confirm_interaction = false
  	self.completed = false
  	return true
  end


  def provider
    User.find(self.provider_id)
  end

  def seeker
    User.find(self.seeker_id)
  end

  def provider_review_for_seeker
    Review.find(self.provider_review_for_seeker_id)
  end

  def seeker_review_for_provider
    Review.find(self.seeker_review_for_provider_id)
  end

  def set_complete
    self.update_attribute(:completed, 1)
    self.update_attribute(:expirable_created_at, nil)
    self.seeker_accept_exchange = true
    self.provider_accept_exchange = true
    self.seeker_confirm_interaction = true
    self.provider_confirm_interaction = true
  end

end
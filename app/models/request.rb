class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users

  field :provider, type: BSON::ObjectId
  field :seeker, type: BSON::ObjectId

  field :seeker_accept_request, type: Boolean
  field :provider_accept_request, type: Boolean  
  field :seeker_confirm_interaction, type: Boolean
  field :provider_confirm_interaction, type: Boolean

  field :provider_review_for_seeker, type: BSON::ObjectId
  field :seeker_review_for_provider, type: BSON::ObjectId

  field :completed, type: Boolean


  # Special date/time field to base expirations on.
  field :expirable_created_at, type: Time

  # TTL index on the above field. Need to run  rake db:mongoid:create_indexes
  index({expirable_created_at: 1}, {expire_after_seconds: 1.month})


  before_create :initialization
  def initialization
  	self.expirable_created_at = Time.now
  	self.seeker_accept_request = false
  	self.provider_accept_request = false
  	self.seeker_confirm_interaction = false
  	self.provider_confirm_interaction = false
  	self.completed = false
  	return true
  end

end
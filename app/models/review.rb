class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  field :authorID, type: BSON::ObjectId
  field :author, type: String
  field :text, type: String
  field :rating, type: Integer

  field :token_digest, type: String
  field :completed, type: Boolean
  

  # Special date/time field to base expirations on.
  field :expirable_created_at, type: Time

  # TTL index on the above field. Need to run  rake db:mongoid:create_indexes
  index({expirable_created_at: 1}, {expire_after_seconds: 1.month})

  # Callback to set `expirable_created_at`
  before_create :set_expire
  def set_expire
	self.expirable_created_at = Time.now
	return true
  end



  attr_accessor :token

  def create_token_digest
    self.token = Review.new_token
    update_attribute(:token_digest,  Review.digest(token))
    update_attribute(:completed, 0)
  end

# Returns the hash digest of the given string.
  def Review.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Review.new_token
    SecureRandom.urlsafe_base64
  end

    # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


end

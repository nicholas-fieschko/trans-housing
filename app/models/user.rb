class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword
  field :name, type: String
  field :is_provider, type: Boolean

  embeds_one :location   # For now, just one location per user.. 
                         # In future, useful to have multiple locations
                         # to match ability to grab lunch for someone near
                         # work, etc.
  embeds_one :gender
  embeds_one :contact    # Ranked contact methods

  embeds_one :preference_profile # User site/security preferences
  embeds_one :extended_profile, validate: false

  embeds_many :reviews
  field :number_reviews, type: Integer

  # has_one :inbox ?


  validates_presence_of :name, :location, :gender 
  # and one login method... such as email or phone...


  field :is_admin, type: Boolean
  field :remember_token, type: String
  field :password_digest, type: String

  has_secure_password

  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

    private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end

class Gender
  include Mongoid::Document
  embedded_in :user

  field :identity, type: String #Male, Female, custom text [bigender, etc..]
  field :trans, type: Boolean

  field :cp, as: :custom_pronouns, type: Boolean
  field :they, type: String
  field :their, type: String
  field :them, type: String

  before_save { self.identity = identity.downcase }

end

class Contact
  include Mongoid::Document
  embedded_in :user

  # To be revised
  field :email, type: String
  field :phone, type: String

  before_save { self.email = email.downcase }

end


class PreferenceProfile
  include Mongoid::Document
  embedded_in :user

end
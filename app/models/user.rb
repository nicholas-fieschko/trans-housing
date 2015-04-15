class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword
  field :name, type: String
  field :is_provider, type: Boolean

  has_one :location   # For now, just one location per user.. 
                         # In future, useful to have multiple locations
                         # to match ability to grab lunch for someone near
                         # work, etc.
  embeds_one :gender
  has_one :contact    # Ranked contact methods
  embeds_one :preference_profile # User site/security preferences
  embeds_one :extended_profile

  # embeds_many :resources

  embeds_many :reviews

  # has_one :inbox ?

  accepts_nested_attributes_for :location, :gender, :contact #, :resources


  validates_presence_of :name, :gender, :contact#, :location
  validates_associated :gender, :contact

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

  field :identity, type: String #Male, Female, other text
  field :trans, type: Boolean

  field :cp, as: :custom_pronouns, type: Boolean
  field :they, type: String
  field :their, type: String
  field :them, type: String

  # VALIDATE TO-DO: No custom pronoun text if custom_pronouns is false,
  # or if "trans" is false!
  validates_presence_of :identity, :trans

  before_save { self.identity = identity.to_s.downcase }
end

class Contact
  include Mongoid::Document
  belongs_to :user

  field :preferred_contact # How best to set?
  field :email, type: String
  field :phone, type: String

  validates_uniqueness_of :email, unless: ->(contact){contact.email.nil?}
  validates_uniqueness_of :phone, unless: ->(contact){contact.phone.nil?}
  validates :email, presence: true, unless: ->(contact){contact.phone.present?}
  validates :phone, presence: true, unless: ->(contact){contact.email.present?}

  before_save { self.email = email.downcase }
end


class PreferenceProfile
  include Mongoid::Document
  embedded_in :user
end

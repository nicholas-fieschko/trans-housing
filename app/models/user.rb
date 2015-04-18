class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  field :name,                   type: String
  field :is_provider,            type: Boolean

  embeds_one :gender
  has_one :contact,              dependent: :delete
  has_one :location,             dependent: :delete
  
  # embeds_one :preference_profile # User site/security preferences
  # embeds_one :extended_profile

  # embeds_many :resources
  # embeds_many :reviews
  # has_one :inbox ?

  accepts_nested_attributes_for  :gender, :contact, :location #, :resources
  validates_presence_of :name,   :gender, :contact#, :location
  validates_associated           :gender, :contact#, :location

  field :is_admin,               type: Boolean
  field :remember_token,         type: String
  field :password_digest,        type: String

  has_secure_password
  before_create :create_remember_token

  def provider?
    self.is_provider
  end
  def seeker?
    !self.is_provider
  end

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
  
  validates :custom_pronouns,     absence: true, if: ->(gender){!gender.trans}
  validates :they, :their, :them, absence: true, if: ->(gender){!gender.trans}
  validates_presence_of :they, :them, :their,    if: ->(gender){gender.trans && gender.custom_pronouns}
  validates_presence_of :identity, :trans


  before_save {
    self.identity = identity.downcase 
    if self.cp
      self.they = they.downcase
      self.them = them.downcase
      self.their = their.downcase
    end
  }
end

class PreferenceProfile
  include Mongoid::Document
  embedded_in :user

end
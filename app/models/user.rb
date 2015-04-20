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

  embeds_one :food_resource
  embeds_one :shower_resource
  embeds_one :laundry_resource
  embeds_one :housing_resource
  embeds_one :transportation_resource
  embeds_one :buddy_resource
  embeds_one :misc_resource

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

  #Pronoun getters to be refactored
  def they
    identity = self.gender[:identity].downcase
    if identity == "male"
      "he"
    elsif identity == "female"
      "she"
    elsif self.gender[:custom_pronouns]
      self.gender[:they]
    else
      "they"
    end
  end

  def their
    identity = self.gender[:identity].downcase
    if identity == "male"
      "his"
    elsif identity == "female"
      "her"
    elsif self.gender[:custom_pronouns]
      self.gender[:their]
    else
      "their"
    end
  end

  def them
    identity = self.gender[:identity].downcase
    if identity == "male"
      "him"
    elsif identity == "female"
      "her"
    elsif self.gender[:custom_pronouns]
      self.gender[:their]
    else
      "them"
    end
  end
        
        

  def provider?
    self.is_provider
  end
  def seeker?
    !self.is_provider
  end

  def offers_food?
    !self.food_resource.nil?
  end
  def offers_shower?
    !self.shower_resource.nil?
  end
  def offers_laundry?
    !self.laundry_resource.nil?
  end
  def offers_housing?
    !self.housing_resource.nil?
  end
  def offers_transportation?
    !self.transportation_resource.nil?
  end
  def offers_buddy?
    !self.buddy_resource.nil?
  end
  def offers_misc?
    !self.misc_resource.nil?
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
  validates :they, :their, :them, absence: true, if: ->(gender){!gender.trans || !gender.custom_pronouns}
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
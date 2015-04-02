class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :name, type: String

  embeds_one :location   # For now, just one location per user.. 
                         # In future, useful to have multiple locations
                         # to match ability to grab lunch for someone near
                         # work, etc.
  embeds_one :gender
  embeds_one :contact    # Ranked contact methods
  # embeds_one :preference # User site/security preferences
  embeds_one :extended_profile, validate: false


  embeds_many :reviews
  field :number_reviews, type: Integer

  # has_one :inbox ?

  #validates_presence_of :name, :location, :gender 
  # and one login method... such as email or phone...


  field :password_digest

  has_secure_password
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

end

class Contact
  include Mongoid::Document
  embedded_in :user

  # To be revised
  field :email, type: String
  field :phone, type: String

  before_save { self.email = email.downcase }
end
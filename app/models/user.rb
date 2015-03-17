class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String
  field :phone, type: String
  
  embeds_one :location  # For now, just one location per user
  embeds_one :gender
  embeds_one :extended_profile, validate: false # Optional
  embeds_many :reviews

  before_save { self.email = email.downcase }
  validates_presence_of :name, :location, :gender 
  # and one login method... either email or phone...
end

class Gender
  include Mongoid::Document
  embedded_in :user

  field :identity, type: String #Male, Female, Bigender, etc..
  field :trans, type: Boolean

  field :they, type: String
  field :their, type: String
  field :them, type: String

end
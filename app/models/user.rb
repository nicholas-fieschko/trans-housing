class User
  include Mongoid::Document
  field :name, type: String
  field :email, type: String #login with email
  
  # field :location, data format ?
  # see Custom Field Serialization on mongoid.org/en/mongoid/docs/documents.html

  field :extended_profile,  type: Hash, 
  							default: { has_extended_profile?: false }
  
  validates_presence_of :name
end
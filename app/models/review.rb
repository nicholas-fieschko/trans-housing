class Review
  include Mongoid::Document

  embedded_in :user

#  field :authorID, type: ObjectId
  field :author, type: String
  field :text, type: String
  field :rating, type: Integer
  
end

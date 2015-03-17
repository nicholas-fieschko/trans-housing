class Review
  include Mongoid::Document

  embedded_in :user
  #Author
  #Text
  #Score?
  
end

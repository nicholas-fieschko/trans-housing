class Resource
  include Mongoid::Document
  embedded_in :user
  field :currently_offered,    type: Boolean
end

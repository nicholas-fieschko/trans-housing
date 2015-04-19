class Resource
  include Mongoid::Document
  embedded_in :user
end

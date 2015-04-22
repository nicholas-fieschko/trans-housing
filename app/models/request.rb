class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users

  field :helper, type: BSON::ObjectId
  field :helpee, type: BSON::ObjectId
  field :review, type: BSON::ObjectId
  field :completed, type: Boolean





end
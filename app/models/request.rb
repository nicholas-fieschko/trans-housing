class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users

  field :provider, type: BSON::ObjectId
  field :seeker, type: BSON::ObjectId
  field :provider_review_for_seeker, type: BSON::ObjectId
  field :seeker_review_for_provider, type: BSON::ObjectId
  field :confirmed, type: Boolean
  field :completed, type: Boolean


end
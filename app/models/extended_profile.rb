class ExtendedProfile
  include Mongoid::Document
  embedded_in :user

  field :profile_summary, type: String

end
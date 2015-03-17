class ExtendedProfile
  include Mongoid::Document

  embedded_in :user

  # Optional personal information fields for a user's profile

end
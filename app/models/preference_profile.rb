class PreferenceProfile
  include Mongoid::Document
  embedded_in :user

  # Whether or not a user wishes to receive notifications
  # by text or email about new messages in their inbox,
  # or new requests/reviews in their dashboard respectively.
  # Default is true for email and false for texts.
  # Key/boolean values: { email: true, text: true }
  field :message_notifs,   as: :message_notifications,     type: Hash
  field :dashboard_notifs, as: :dashboard_notifications,   type: Hash


end
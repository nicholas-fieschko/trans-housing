class Gender
  include Mongoid::Document
  embedded_in :user

  field :identity,                  type: String
  field :trans,                     type: Boolean

  field :cp, as: :custom_pronouns,  type: Boolean
  field :they,                      type: String
  field :their,                     type: String
  field :them,                      type: String

  
  validates :custom_pronouns,       absence: true, if: ->(gender){!gender.trans}
  validates :they, :their, :them,   absence: true, if: ->(gender){!gender.trans ||
                                                         !gender.custom_pronouns}
  validates_presence_of :they, :them, :their,      if: ->(gender){gender.trans &&
                                                                  gender.custom_pronouns}
  validates_presence_of :identity, :trans

  before_validation {
    self.identity = self[:identity].downcase 
    if self.cp
      self.they   = self[:they].downcase  unless self[:they].nil?
      self.them   = self[:them].downcase  unless self[:them].nil?
      self.their  = self[:their].downcase unless self[:their].nil?
    end
  }

end
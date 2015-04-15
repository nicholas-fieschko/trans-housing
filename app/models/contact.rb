class Contact
  include Mongoid::Document
  belongs_to :user

  field :preferred_contact # How best to set?
  field :email, type: String
  field :phone, type: String

  validates_uniqueness_of :email, unless: ->(contact){contact.email.nil?}
  validates_uniqueness_of :phone, unless: ->(contact){contact.phone.nil?}
  validates :email, presence: true, unless: ->(contact){contact.phone.present?}
  validates :phone, presence: true, unless: ->(contact){contact.email.present?}

  before_validation do
    self.email = email.downcase unless email.nil?
  end
end
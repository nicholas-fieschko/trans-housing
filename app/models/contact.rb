class Contact
  include Mongoid::Document
  belongs_to :user

  field :email, type: String
  field :phone, type: String

  validates_presence_of :user

#  validates :email, presence: true, unless: ->(contact){contact.phone.present?}
#  validates :phone, presence: true, unless: ->(contact){contact.email.present?}

  before_validation do
    self.email = email.downcase unless email.nil?
  end

#  validates_uniqueness_of :email, unless: ->(contact){contact.email.blank?}
#  validates_uniqueness_of :phone, unless: ->(contact){contact.phone.blank?}

  def preferred_contact
    if self.prefers_email
      self.email
    else
      self.phone
    end
  end

end

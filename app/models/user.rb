class User
	
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword


  field :name,                              type: String
  field :is_provider,                       type: Boolean


  embeds_one :gender
  has_one    :contact,                      dependent: :delete
  has_one    :location,                     dependent: :delete

  embeds_one :preference_profile
  # embeds_one :extended_profile

  embeds_one :food_resource
  embeds_one :shower_resource
  embeds_one :laundry_resource
  embeds_one :housing_resource
  embeds_one :transportation_resource
  embeds_one :buddy_resource
  embeds_one :misc_resource

  has_many :reviews
  field :number_reviews,                    type: Integer
  field :sum_rating,                        type: Float
  field :average_rating,                    type: Float

  has_and_belongs_to_many :requests

	has_many :conversations
  has_many :messages

  accepts_nested_attributes_for  :gender, :contact,
                                 :food_resource, :shower_resource, :laundry_resource,
                                 :housing_resource, :transportation_resource,
                                 :buddy_resource, :misc_resource, :location
  validates_presence_of          :gender, :contact, :name,
                                 :food_resource, :shower_resource, :laundry_resource,
                                 :housing_resource, :transportation_resource,
                                 :buddy_resource #, :location
  validates_associated           :gender, :contact#, :location


  field :remember_token,         type: String
  field :password_digest,        type: String

  has_secure_password
  before_create :create_remember_token, :initialization

  def pronoun(tense)
    standard_pronouns = { "male" => 
                          {"they" => "he",
                           "them" => "him", 
                           "their" => "his"},
                         "female" => 
                          {"they" => "she",
                           "them" => "her", 
                           "their" => "her"} }
    identity = self.gender[:identity].downcase
    standard_pronouns.has_key?(identity) ? standard_pronouns[identity][tense] : nil ||
    self.gender[tense.to_sym] ||
    tense
  end

  # Returns true if JSON from mailgun API call contains true "is_valid" field
  # Description of validator in Mailgun docs; multimap doesn't work for Ruby 2
  def mailgun_valid?(email)
    #url_params = Multimap.new
    url_params = {}
    url_params[:address] = email
    query = url_params.collect {|k,v| "#{k.to_s}=#{CGI::escape(v.to_s)}"}.join("&")
    response = 
      RestClient.get "https://api:pubkey-d005c8be2308c95c34d7b9924a2b7fa7@api.mailgun.net/v3/address/validate?#{query}"
    hash = JSON.parse response
    hash["is_valid"]
  end
  
	def they
    self.pronoun "they"
  end

  def them
    self.pronoun "them"
  end

  def their
    self.pronoun "their"
  end

  def provider?
    self.is_provider
  end
  def seeker?
    !self.is_provider
  end

  def food?
    self.food_resource[:currently_offered]
  end
  def shower?
    self.shower_resource[:currently_offered]
  end
  def laundry?
    self.laundry_resource[:currently_offered]
  end
  def housing?
    self.housing_resource[:currently_offered]
  end
  def transportation?
    self.transportation_resource[:currently_offered]
  end
  def buddy?
    self.buddy_resource[:currently_offered]
  end
  def misc?
    self.misc_resource[:currently_offered]
  end

  def prefs
    self.preference_profile
  end

  # Retrieve whether or not a user has enabled receipt of 
  # new message notifications by text message.
  # Default is false. 
  def receives_message_notifs_by_text?
    if self.prefs.nil? || self.prefs.message_notifs.nil? ||
       self.prefs.message_notifs[:text].blank? ||
       self.prefs.message_notifs[:text] == false
      false
     elsif self.prefs.message_notifs[:text] == true
      true
    end
  end

  # Retrieve whether or not a user has enabled receipt of 
  # new message notifications by email message.
  # Default is true. 
  def receives_message_notifs_by_email?
    if self.prefs.nil? || self.prefs.message_notifs.nil? ||
       self.prefs.message_notifs[:email].blank? ||
       self.prefs.message_notifs[:email] == true
      true
     elsif self.prefs.message_notifs[:email] == false
      false
    end
  end

  # Retrieve whether or not a user has enabled receipt of 
  # new dashboard (request/offers/reviews) notifications by 
  # text message.
  # Default is false. 
  def receives_dashboard_notifs_by_text?
    if self.prefs.nil? || self.prefs.dashboard_notifs.nil? ||
       self.prefs.dashboard_notifs[:text].blank? ||
       self.prefs.dashboard_notifs[:text] == false
      false
     elsif self.prefs.dashboard_notifs[:text] == true
      true
    end
  end

  # Retrieve whether or not a user has enabled receipt of 
  # new dashboard (request/offers/reviews) notifications by 
  # email message.
  # Default is true. 
  def receives_dashboard_notifs_by_email?
    if self.prefs.nil? || self.prefs.dashboard_notifs.nil? ||
       self.prefs.dashboard_notifs[:email].blank? ||
       self.prefs.dashboard_notifs[:email] == true
      true
     elsif self.prefs.dashboard_notifs[:email] == false
      false
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.search(search)
    if search
      any_of({name: /#{search}/i}, {city: /#{search}/i})
    else
      self.all.to_a
    end
  end

  def self.numerical_options
    ["1","2","3","4","5","6","7","8","9","10"]
  end

  def self.resources_list
    ["Housing",
     "Food",
     "Shower",
     "Laundry",
     "Transportation",
     "Misc"]
  end

  def self.integer_from_options_list(options_list)
    # convert options list given by radio buttons into one-hot integer
    resources = 0;
    if options_list
      options_list.each do |option|
        resources += 2 ** option.to_i
      end
    end

    resources
  end

  def self.find_with_filters(filters)

    filtered_users = User.all

    # if filters[:city] && filters[:city].length > 0
    #   filtered_users = filtered_users.near(filters[:city], 30)
    # end

    if filters[:resources]
      resources = User.integer_from_options_list(filters[:resources])
      # filtered_users = filtered_users.where({"resources & ? = ?", resources, resources})
    end

    filtered_users
  end

  def set_resources_from_options_list!(options_list)
    self.resources = User.integer_from_options_list(options_list)
  end

  def boolean_array_from_resources_integer
    [].tap do |resources_list|
      User.resources_list.length.times do |order|
        resources_list << (self.resources & 2 ** order > 0)
      end
    end
  end

    private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

    def init_reviews
      self.number_reviews = 0
      self.average_rating = 0
      self.sum_rating = 0
    end

    def initialization
      init_reviews
      self.preference_profile ||= PreferenceProfile.new
    end

end

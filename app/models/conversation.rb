class Conversation
  include Mongoid::Document
	
	# Fields
	

	# Relations
	has_and_belongs_to_many :users
	has_many :messages


	# Methods...


end

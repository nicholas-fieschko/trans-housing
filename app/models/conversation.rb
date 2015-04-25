class Conversation
  include Mongoid::Document
	include Mongoid::Timestamps::Updated
	
	# 'Creation' isn't relevant for sorting; use the most recent message time
	# as the update field for the conversation
	default_scope -> { order(updated_at: :desc) }

	# Fields
	field :updated_at, type: Time, default: Time.now	
	field :subject, type: String

	# {userID: visible_to} keeps track of which members
	# 	of conversation still have links to the convo (that is, true
	#	means they have NOT deleted their link to convo)
	# field :visible_to, type: Hash

	# Relations
	has_and_belongs_to_many :users
	has_and_belongs_to_many :owners, class_name: 'User', inverse_of: nil
	has_many :messages, order: :updated_at.desc

	# Validations
	validates_length_of :subject, minimum: 1, maximum: 300

	def remove_owner(current_user)
		self.owner_ids.delete(current_user)

		# Exclamation raises exception on failure
		if self.owner_ids.empty?
			self.destroy!
		end

		# Otherwise, don't do anything
	end


	# Callbacks
	before_save {
		# No deletes yet! Make a copy (only on initial creation)
		self.owner_ids = self.user_ids.dup
	}

	before_update {}

	#before_remove {}

	# Private methods for use by the callbacks
	protected



end

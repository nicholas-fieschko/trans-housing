class Conversation
  include Mongoid::Document
	include Mongoid::Timestamps::Updated
	
	# 'Creation' isn't relevant for sorting; use the most recent message time
	# as the update field for the conversation
	default_scope -> { order(updated_at: :desc) }

	# Fields
	field :updated_at, type: Time, default: Time.now	
	field :subject, type: String
	field :owners, type: Array, default: []
	field :readers, type: Array, default: []

	# Relations: owners is all those who haven't deleted
	has_and_belongs_to_many :users
	has_many :messages, order: :updated_at.desc

	# Validations
	validates_length_of :subject, minimum: 1, maximum: 300


	### METHODS for manipulating user inbox ###
	# - Like unix inode, message is hard-deleted once all owners delete it
	def remove_owner(current_user)
		self.owners.delete(current_user.id)
		self.save!
		if self.owners.empty?
			self.destroy! # Exclamation raises exception on failure
		end
	end
	# - Returns true if the current_user has not yet been pushed to readers array
	def unread_conversation?(current_user)
		self.readers.exclude? current_user.id
	end
	# - Returns true if conversation has been deleted by the user
	def deleted_conversation?(current_user)
		self.owners.exclude? current_user.id
	end
	def print_owners
		label = '['
		self.owners.each do |o|
			label += User.find(o).name + ', '
		end
		return label[0..-3] += ']'
	end

	# Callbacks
	before_save {
		# Owners defaults to everybody
		#self.owners = self.user_ids.dup
		# Readers defaults to just the creator (set in conversation#new)
	}

	before_update {


	}

	#before_remove {}

	# Private methods for use by the callbacks
	protected



end

class Array
	
	def completed
		self.select { |n| n.completed }
	end

	def uncompleted
		self.select { |n| !n.completed}
	end

end
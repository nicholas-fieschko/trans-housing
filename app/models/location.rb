class Location
  include Mongoid::Document
  belongs_to :user
  
  field :c, as: :coordinates, type: Array             # [longitude, latitude]

  # Validation: longitude is between -180 and 180
  # Validation: latitude is between -90 and 90
  validates_presence_of :coordinates
 
  # Create 2D Geospatial Index
  index({ coordinates: "2d" }, { min: -200, max: 200 })  

  def lng
    self.coordinates.first
  end
  def lat
    self.coordinates.last
  end
	

  def search(query)
	if query
		self.where(location=>
		{ $near =>
			{
				$geometry => {type:"Point",coodinates:[query.lat,query.lng]},
				$maxDistance => 16100 # ~10 miles
			}
		}).to_json
	# TODO: better error handel here
	else
		[].to_json
	end
  end	
end

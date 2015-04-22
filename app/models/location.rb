class Location
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :user
  
  field :c, as: :coordinates, type: Array             # [longitude, latitude]
  field :zip,                 type: String
  field :city,                type: String
  field :state,               type: String
  field :country,             type: String

  # Validation: longitude is between -180 and 180
  # Validation: latitude is between -90 and 90
  validates_presence_of :coordinates
 
  # Create 2D Geospatial Index
  index({ coordinates: "2dsphere" }, { min: -200, max: 200 })

  # db.trans_housing_test.ensureIndex({"location":"2dsphere"})
  # db.trans_housing_test.find({"location": {"$nearSphere": { "$geometry": { "type": "Point", "coordinates": [47, -71]}, "$maxDistance": 2000000000}}})


  def lng
    self.coordinates.first
  end
  def lat
    self.coordinates.last
  end
	

  def search(query)
	@distance = 10000
	if query
		Location.where("coordinates" => {
			"$nearSphere"=> {"$geometry"=> {
			"type"=> "Point",
			"coordinates"=> [query[0].to_f, query[1].to_f],
			"$maxDistance"=> @distance}
		}}).to_a.map{|loc| loc.user}
		#Location.where(:coordinates =>
		#{ '$near' => [query[0].to_f,query[1].to_f],
				#{
				# "$geometry" => {type:"Point",coodinates: query},
		#	'$maxDistance' => @distance.fdiv(69) # ~10 miles
			#}
		
		#}).to_json
	# TODO: better error handel here
	else
		[].to_a
	end

  end	
end

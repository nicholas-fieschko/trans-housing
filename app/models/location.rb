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
	

  def search(query, filters, zoomlevel, iniflg)
	if iniflg == "ini" && self.city && 
		self.city != "Unknown Location" 
		if !self.coordinates
			@cor = Geokit::Geocoders::GoogleGeocoder.geocode(
					self.city + " " + self.state)
			if @cor.success
				self.coordinates = [@cor.lng, @cor.lat]
			end
		end
		query = self.coordinate
	end

    # Little hack here...should use lnglatRange() 
    @zoom = zoomlevel.to_i
    @distance = 2*(2**(15-@zoom))
    if query
      nearbyUsers = Location.where("coordinates" => {
                                     "$nearSphere" => {"$geometry" => {
                                         "type" => "Point",
                                         "coordinates"=> [query[1].to_f, query[0].to_f]
                                       },
                                       "$maxDistance"=> @distance*1609}}
                                   ).to_a.map{|loc| loc.user}
      filter_by_user_type(nearbyUsers,filters) & filter_by_resource(nearbyUsers,filters)
      # TODO: better error handel here
    else
      [].to_a
    end
  end	
  
  private

  def filter_by_user_type(users, filters) 
    user_type_filters = filters.select { |f| User.all_user_type_filters.include?(f) }
    filter(users,user_type_filters)
  end
  
  def filter_by_resource(users, filters)
    resource_filters = filters.select { |f| User.all_resource_filters.include?(f) }
    filter(users,resource_filters)
  end
  
  def filter(users, filters)
    users.select { |u| filters.select{|f| u.send("#{f}?")}.any? }
  end
  
end

class Location
  include Mongoid::Document

  belongs_to :user
  
  # GeoJSON
  # See http://docs.mongodb.org/manual/tutorial/build-a-2dsphere-index/
  # field :geojson # { type: "Point", coordinates: [longitude, latitude] }
  
  # Conversion of addresses and 
  # https://developers.google.com/maps/documentation/geocoding/
  # field :streets # [street 1, street 2] ?

end
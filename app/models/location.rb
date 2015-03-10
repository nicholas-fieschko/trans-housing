class Location
  include Mongoid::Document

  # GeoJSON - which fields should, could be auto-generated?
  # field coordinates # latitude, longitude
  # field street_intersection [street 1, street 2]

end

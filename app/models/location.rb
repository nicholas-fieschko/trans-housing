class Location
  include Mongoid::Document
  belongs_to :user
  
  field :c, as: :coordinates, type: Array             # [longitude, latitude]
  index({ location: "2d" }, { min: -200, max: 200 })  # Create 2D Geospatial Index

  # Validation: longitude is between -180 and 180
  # Validation: latitude is between -90 and 90

  def lng
    self.coordinates.first
  end
  def lat
    self.coordinates.last
  end

end
class Location
  include Mongoid::Document
  belongs_to :user
  
  field :c, as: :coordinates, type: Array             # [longitude, latitude]

  # Validation: longitude is between -180 and 180
  # Validation: latitude is between -90 and 90
  validates_presence_of :coordinates
  
  index({ coordinates: "2d" }, { min: -200, max: 200 })  # Create 2D Geospatial Index

  def lng
    self.coordinates.first
  end
  def lat
    self.coordinates.last
  end

end

class LocationsController < ApplicationController
  include Geokit::Geocoders

  def index
  end

  def search
    location = Location.new
	@nearbyUsers = location.search(params[:loc])
	if @nearbyUsers
	  @location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode params[:loc]
      session[:location] = { zip: @location.zip,
                             city: @location.street_address + ", " + 
								   @location.city,
                             state: @location.state }
	  session[:coordinates] = params[:loc]

	  render:json => Hash[@nearbyUsers.collect { |v| [v.id, v.as_document.as_json.
			merge!("location"=> v.location.as_document.as_json)] }]

	else
		flash.now[:error] = "Location error..."
	end			 	
  end
end

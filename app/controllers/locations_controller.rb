class LocationsController < ApplicationController
  def index
#	coordinates=Geokit::Geocoders::CaGeocoder.geocode(location)
  end

  def search
    location = Location.new
	@nearbyUsers = location.search(params[:loc])
	if @nearbyUsers
		render:json => { :users => @nearbyUsers }	
	else
		flash.now[:error] = "Location error..."
	end			 	
	#respond_to do |format|
	#	format.json
	#end
  end
end

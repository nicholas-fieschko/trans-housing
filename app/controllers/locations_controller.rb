class LocationsController < ApplicationController
  def index
#	coordinates=Geokit::Geocoders::CaGeocoder.geocode(location)
  end

  def search
    location = Location.new
	@nearbyUsers = location.search(params[:loc])
	if @nearbyUsers
		print @nearbyUsers

		render:json => Hash[@nearbyUsers.collect { |v| [v.id, v.as_document.as_json.
			merge!("location"=> v.location.as_document.as_json)] }]
#		render:json => Hash[@nearbyUsers.collect { |v| [v.id, v.as_document.as_json.merge!(location: v.loc)] }]


	else
		flash.now[:error] = "Location error..."
	end			 	
  end
end

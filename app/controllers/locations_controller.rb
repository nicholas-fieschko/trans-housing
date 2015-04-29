class LocationsController < ApplicationController
  include Geokit::Geocoders

  def index
  end

  def search
    location = Location.new
	if params[:iniflag] == "1" && 
		session[:location] && session[:location]["state"] != "Unknown"
		if session[:coordinate]
			@nearbyUsers = location.search(session[:coordinate].reverse)
		else 
			@cor = Geokit::Geocoders::GoogleGeocoder.geocode(
				session[:location]["city"] + session[:location]["state"])
			if @cor.success
				session[:coordinate] = [@cor.lng, @cor.lat]
				@nearbyUsers = location.search(session[:coordinate])
			else 
				@nearbyUsers = location.search(params[:loc])
			end
		end
		
	else
		@nearbyUsers = location.search(params[:loc])
	end

	if @nearbyUsers
	  #if @params[:loc].is_a?(Hash)
	  #	print @params[:loc]
	  #	@location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode 
	  #				[(params[:loc][:"0"][0].to_f+params[:loc][:"0"][1].to_f)/2, 
	  #				(params[:loc][:"1"][0].to_f+params[:loc][:"1"][1].to_f)/2]
	  #else
	  @location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode params[:loc]
	  #end
	  # TODO: there should be more checking wrapping around zip/city/state
	  # or move the checking to model 
	  if not session[:location]
		if @location && @location.street_address && @location.city
			session[:location] = { zip: @location.zip,
								 city: @location.street_address + ", " + 
									   @location.city,
								 state: @location.state }
			session[:coordinates] = params[:loc].reverse
		else 
			session[:location] = { zip: 000000, city: "Unknown Location", 
									 state: "Unknown"}
			session[:coordinates] = [-72.9267, 41.3111]
		end
	  end


	  # TODO: can we think of other things to hide?
	  @usrLogInFlg = 1;
	  if !signed_in?
		@idx = 0
		@usrLogInFlg = 0
        @nearbyUsers.map{|usr| @idx+=1; usr.name = usr.name[0] + "."; usr._id = @idx }
      end
	  @returnArray = @nearbyUsers.collect { |v| [v.id, v.as_document.as_json.
			merge!("location"=> v.location.as_document.as_json, 
				   "loginflag"=> @usrLogInFlg)]}
	  @returnArray.push(["usrNewLoc", 
	  	{"usrNewLoc" => session[:coordinates]}.as_json])
	  render:json => Hash[@returnArray]

	 else
	 	flash.now[:error] = "Location error..."
	 end			 	
	 end
  end

class LocationsController < ApplicationController
  include Geokit::Geocoders

  def index
  	@all_user_type_filters = User.all_user_type_filters
  	@all_resource_filters = User.all_resource_filters
  	if !cookies[:filters] 
  		save_filters(@all_user_type_filters + @all_resource_filters)
  	end
  	@filters = filters_array
  end


  def search
    location = Location.new
	@nearbyUsers = location.search(params[:loc])
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

	  # TODO: can we think of other things to hide?
	  @usrLogInFlg = 1;
	  if !signed_in?
		@idx = 0
		@usrLogInFlg = 0
        @nearbyUsers.map{|usr| @idx+=1; usr.name = usr.name[0] + "."; usr._id = @idx }
      end
	  render:json => Hash[@nearbyUsers.collect { |v| [v.id, v.as_document.as_json.
			merge!("location"=> v.location.as_document.as_json, 
				   "loginflag"=> @usrLogInFlg)] }]

	else
		flash.now[:error] = "Location error..."
	end			 	
  end

  private
  	def save_filters(filters)
  		cookies.permanent[:filters] = (filters.class == Array) ? filters.join(',') : ''
	end

	def filters_array
  		cookies[:filters] ? cookies[:filters].split(",") : []
	end

end

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
    if params[:iniflag] == "1" && signed_in? &&
		@nearbyUsers = location.search(params[:loc], filters_array, 
									   params[:zoom], "ini")
    else
        @nearbyUsers = location.search(params[:loc], filters_array, 
									   params[:zoom], "rep")
    end
    
    if @nearbyUsers
      @location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode params[:loc]
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
        # We need unique ids....so keep user id exposed...
        # can use a hash function in the future
        @nearbyUsers.map{ |usr| usr.name = "Please sign in for details." } #usr.name[0] + "." }
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
  
  private
  
  def save_filters(filters)
    cookies.permanent[:filters] = (filters.class == Array) ? filters.join(',') : ''
  end
  
  def filters_array
    cookies[:filters] ? cookies[:filters].split(",") : []
  end
end

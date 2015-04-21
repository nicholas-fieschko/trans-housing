var map;
var infowindow = new google.maps.InfoWindow();

$(document).ready(function() {
	var url = "/location/posts"
	initialize();
       	/*function(){
	    var markerData = <%= raw @hash.to_json %>;
	    updateMarkers(map, markersData);
	    });*/
    });


function initialize() {
    var initialLocation;
    var yale = new google.maps.LatLng(41.31845, -72.92226);
    var browserSupportFlag = new Boolean();
    var map_canvas = document.getElementById('map_canvas');
    var map_options = {
	zoom: 14,	  
	mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(map_canvas, map_options);
    // Try W3C Geolocation 
    // (https://developers.google.com/maps/articles/geolocation)
    if (navigator.geolocation) {
	browserSupportFlag = true;
	navigator.geolocation.getCurrentPosition(function(position) {
		initialLocation = new google.maps.LatLng(position.coords.
							 latitude, position.
							 coords.longitude);
		map.setCenter(initialLocation);
		// We want to put a marker on our location
		var myLatLng = new google.maps.LatLng(initialLocation.lat(), 
						      initialLocation.lng());
		var marker = new google.maps.Marker ({
			position:myLatLng,
			map: map,	
		});
		queryNearbyUsers(initialLocation.lat(), initialLocation.lng());
	    },function (){
		handleNoGeolocation(browerSupportFlag);
	    });
    }
    else {
	browserSupportFlag = false;
	handleNoGeolocation(browserSupportFlag);
    }
}


function handleNoGeolocation(errorFlag) {
    if (errorFlag == true) {
	alert("Geolocation service failed...");
    } 
    initialLocation = yale;
    map.setCenter(initialLocation)
}

function queryNearbyUsers(lat, lng, map) {
    var url = "/location/posts";
    var loc = { 'lat': lat, 'lng': lng };
        $.ajax({
		type: "POST",
		url: url,
		data: loc,
		dataType: 'json',
		success: function(data) {
		    var userData = JSON.parse(data);
		    $(userData).each(function(userInfo) {
			addMarkers(map, userInfo);
			});
		}
	    })
	}

function addMarkers(map, usr) {
    // console.log(p)
	if (usr.is_provider) {
	    var image = {
		icon: "<%=asset_path('house.png') %>",
		size: new google.maps.Size(32, 32),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(12,12)
                };
        }
    
	else {
	    var image = {
		icon: "<%=asset_path('people.png') %>",
		size: new google.maps.Size(32, 32),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(12,12)
                };    
        }
    var shape = {
	coords: [1, 1, 1, 20, 18, 18, 1], 
	type: 'poly'
    };

    var contentString = '<div id="content">'+ 
	'<div id="siteNotice">'+
	'</div>'+
	'<h1 id="firstHeading" class="firstHeading">' + usr.name + '</h1>'+
	'<div id="bodyContent"><p>' + usr.gender + '<br><b>' + usr.contact + 
	'</b></div>'+'</div>';
    
    //      var infowindow = new google.maps.InfoWindow({
    //            content: contentString
    //        });
    
    var myLatLng = new google.maps.LatLng(usr.Location.lng, usr.Location.lat);
    var marker = new google.maps.Marker({
	    position: myLatLng,
	    icon: image,
	    map: map,
	    title: usr.name,
	    //      shape: shape
	    zIndex: parseInt(p[5])
	});
    google.maps.event.addListener(marker, 'click', function() {
	    infowindow.close();
	    infowindow.setContent(contentString);
	    infowindow.open(map,marker);
        });
}
google.maps.event.addListener(window, 'click', function() {
	infowindow.close();
    });
//   google.maps.event.addDomListener(window, 'load', initialize);

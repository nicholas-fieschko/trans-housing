var lines = [];
var map;
var infowindow = new google.maps.InfoWindow();
var initialLocation;
var yale = new google.maps.LatLng(41.31845, -72.92226);
var browserSupportFlag = new Boolean();

$(document).ready(function() {
	/* $.ajax({
	   type: "POST",
	   url: "fake.csv",
	   dataType: "text",
	   success: function(data) {
	   processData(data);
	   }
	   });*/
	initialize();
    });

function processData(allText) {
    var allTextLines = allText.split(/\r\n|\n/);
    for (var i=0; i<allTextLines.length; i++) {
	var data = allTextLines[i].split(",");
	if (data.length == 6) {
	    var tarr = [];
	    for (var j=0; j<6; j++) {
		tarr.push(data[j]);
	    }
	    lines.push(tarr);
	}
    }
    initialize();
}

function initialize() {
    var map_canvas = document.getElementById('map_canvas');
    var map_options = {
	zoom: 12,
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
    userCursor = db.trans_housing_development.find
	(
	 { 
	     location:
	     { $near: 
	       {
		   $geometry:{ type:"Point", coordinates:[lat, lng] },
		   $maxDistance: 8046 // This is 5 miles in meters
	       }
	     }
	 }
	 ) 		     	 
    while (userCursor.hasNext()) {
	addMarkers(map, myCursor.next());
    }
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

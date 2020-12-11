var geolocate = document.getElementById('geolocate');

//if available, find user approximate location
if (!navigator.geolocation) {
    geolocate.innerHTML = 'Geolocation is not available';
} else {
    geolocate.onclick = function (e) {
        var options = { enableHighAccuracy: true };
        navigator.geolocation.getCurrentPosition(function(position, html5Error, options) {

            geo_loc = processGeolocationResult(position);
            currLatLong = geo_loc.split(",");
            reverseGeocoding(currLatLong[0], currLatLong[1]);
        });
    };
}

//process results to get lat, lng
function processGeolocationResult(position) {

    html5Lat = position.coords.latitude;
    html5Lon = position.coords.longitude;
    html5TimeStamp = position.timestamp;
    html5Accuracy = position.coords.accuracy;
    return (html5Lat).toFixed(8) + ", " + (html5Lon).toFixed(8);
}

//use mapbox reverse geocoding to get address from lat, lng
const request = require('request');
var ACCESS_TOKEN = 'pk.eyJ1Ijoidnl2eCIsImEiOiJja2hvNHpoNWMwdzY5MnBxcXVkZW1ldG5sIn0.H34EuAUYbhKcNbvq2wRnYw';
  
const reverseGeocoding = function (latitude, longitude) { 
  
    var url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/'
            + longitude + ', ' + latitude 
            + '.json?access_token=' + ACCESS_TOKEN; 
  
    request({ url: url, json: true }, function (error, response) { 
        if (error) { 
            //console.log('Unable to connect to Geocode API');
            document.getElementById('message').innerHTML = 'Unable to connect to Geocode API'; 
        } else if (response.body.features.length == 0) { 
            //console.log('Unable to find location.');
            document.getElementById('message').innerHTML = 'Unable to find location.'; 
        } else {
            //console.log(response.body.features[0].place_name);
            //document.getElementById('result').innerHTML += response.body.features[0].place_name;
            addResponseAddress(response.body.features[0].place_name);
        }
    })
}

function addResponseAddress(addr) {
    var parts = addr.split(", ");
    document.getElementById("country").value = parts[parts.length - 1];
    document.getElementById("state").value = parts[parts.length - 2];
    document.getElementById("city").value = parts[parts.length - 3];
    document.getElementById("street").value = addr.split(", " + parts[parts.length - 3])[0];
}

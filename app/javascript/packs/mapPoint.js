//show a map with a single location pointer

if (gon.e_lng != null && gon.cu_lng != null) {
    //show both points on map
    var eCoords = {lng: gon.e_lng, lat: gon.e_lat}; //event coords
    var uCoords = {lng: gon.cu_lng, lat: gon.cu_lat}; //current user coords
    var mCoords = {lng: (gon.e_lng + gon.cu_lng) / 2, lat: (gon.e_lat + gon.cu_lat) / 2}; //midpoint coords
    //show single point on map
    mapboxgl.accessToken = 'pk.eyJ1Ijoidnl2eCIsImEiOiJja2hvNHpoNWMwdzY5MnBxcXVkZW1ldG5sIn0.H34EuAUYbhKcNbvq2wRnYw';
    var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v11',
        center: mCoords,
        zoom: 10
    });
    // Add zoom and rotation controls to the map.
    map.addControl(new mapboxgl.NavigationControl());

    var marker = new mapboxgl.Marker()
    .setLngLat(eCoords)
    .setPopup(new mapboxgl.Popup().setHTML("<p>The event is here</p>"))
    .addTo(map);
    var marker = new mapboxgl.Marker()
    .setLngLat(uCoords)
    .setPopup(new mapboxgl.Popup().setHTML("<p>You are here</p>"))
    .addTo(map);
} else if (gon.e_lng != null) {
    var eCoords = {lng: gon.e_lng, lat: gon.e_lat}; //event coords
    //show single point on map
    mapboxgl.accessToken = 'pk.eyJ1Ijoidnl2eCIsImEiOiJja2hvNHpoNWMwdzY5MnBxcXVkZW1ldG5sIn0.H34EuAUYbhKcNbvq2wRnYw';
    var map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v11',
        center: eCoords,
        zoom: 10
    });
    // Add zoom and rotation controls to the map.
    map.addControl(new mapboxgl.NavigationControl());

    var marker = new mapboxgl.Marker()
    .setLngLat(eCoords)
    .addTo(map);
} else {
    //don't show map
    document.getElementById("map-container").style.display = none;
}


var map;
var markers = [];
var client  = spore.create(twitter_spec,function(a){ client=a });

function get_location( base_url, location, callback, option ) {

    if( location ) {

        $.ajax( {
            url: base_url,
            dataType: 'json',
            data: { "location": location },
            error: function( r ) {
                alert( "error: " + r );
            },
            success: function( data ) {
                callback( data.lat, data.lng, option );
            }
        } );

    }
}

var move = function( lat, lng, zoom ) {

    var latlng = new google.maps.LatLng(lat, lng);
    var myOptions = {
      zoom: ( zoom ) ? zoom : 2,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    if( map ) {
        map.setCenter( latlng );
        map.setZoom( zoom );
    }
    else {
        map = new google.maps.Map( document.getElementById("map_canvas"), myOptions );
    }

}

var mark = function( lat, lng, user ) {

    var latlng = new google.maps.LatLng(lat, lng);

    var marker = new google.maps.Marker({
        position: latlng,
        title: user.name,
    });

    markers.push( marker );

    marker.setMap( map );
}

function clean_all() {
    for( var i in markers ) {
        markers[i].setMap( null );
    }
    markers.length = 0;

    $( '#result > ul' ).empty();
}

function search( base_url, query ) {

    clean_all();

    twitter( query );

    $.ajax( {
        url: base_url,
        dataType: 'json',
        data: { "query": query },
        error: function( r ) {
            alert( "error: " + r );
        },
        success: function( data ) {
            if( data.users.length > 0 ) {
                for( var i in data.users ) {
                    get_location( where_url, data.users[i].location, mark, data.users[i] );
                }
                get_location( where_url, data.users[0].location, move, 4 );
            }
            else {
                $( '#return' ).text('No results');                
            }
        }
    } );

}

function twitter( query ) {
    client.search(
        { "format": "json", "q": query },
        function( d, r ) {
            for( var i in d.results ) {
                var tweet = d.results[i];
                $( '<li>' )
                    .text( '@' + tweet.from_user + ': ' + tweet.text )
                    .appendTo( '#result > ul' );
            }
	    }, function( r ) {
		    alert('error: ' + r);
	    }
    );
}

function search( base_url, query ) {

    $.ajax( {
        url: base_url,
        dataType: 'json',
        data: { "query": query },
        error: function( msg ) {
            alert( "Error !: " + msg );
        },
        success: function( data ) {
//    	    $( '#result' ).text( data.query );
            display( data );
            draw( data );
        }
    } );

}

function display( data ) {


}

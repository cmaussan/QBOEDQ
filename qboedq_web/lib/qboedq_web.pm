package qboedq_web;
use Dancer ':syntax';

use CHI;
use Net::HTTP::Spore;
use Try::Tiny;
use YAML::XS;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/search' => sub {
    my $query = params->{ query };
    debug "query: $query";

    my $client = _client( 'github' );

    my $res;
    try {
        $res = $client->user_search( format => 'json', search => $query );
        debug Dump $res;
    }
    catch {
        error Dump $_;
    };    
    
    my $data = { query => $query };

    if( $res ) {
        $data->{ users } = $res->body->{ users };
    } 

    return to_json( $data );
};

get '/where' => sub {
    my $location = params->{ location };
    debug "query: $location";

    my $cache = CHI->new( driver => 'File', root_dir => '/tmp/qboedq' );
    my $data = $cache->get( $location );
    unless( defined $data ) {

        my $client = _client( 'googlemaps' );

        my $res;
        try {
            $res = $client->geocode( 
                format => 'json', 
                address => $location,  
                sensor => 'false',
            );
            debug Dump $res;
        }
        catch {
            error Dump $_;
        };    
        
        $data = $res->body->{ results }->[0]->{ geometry }->{ location };
        $cache->set( $location, $data, "24h" );
    }

    return to_json( $data );
};


get '/spec/:service' => sub {
    my $service = params->{ service };
    if( defined config->{ spore }->{ $service } ) {
        return send_file( config->{ spore }->{ $service }->{ spec }, system_path => 1 );
    }
    else {
        return to_json( {} );
    }
};

sub _client {
    my $service = shift;

    my $client = Net::HTTP::Spore->new_from_spec(
        config->{ spore }->{ $service }->{ spec },
        base_url => config->{ spore }->{ $service }->{ base_url },
    );
    $client->enable( 'Format::JSON' );

    return $client;
}

true;

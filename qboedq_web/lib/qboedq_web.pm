package qboedq_web;
use Dancer ':syntax';

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
        $data->{ github } = $res->body->{ users };
    } 

    return to_json( $data );
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

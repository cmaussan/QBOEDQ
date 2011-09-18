
use strict;
use warnings;

use 5.010;

use Getopt::Long;
use Net::HTTP::Spore;
use Try::Tiny;
use YAML::XS qw( LoadFile Dump );

my $conf_file = undef;

GetOptions(
    'conf_file=s'  => \$conf_file,
);

die "--conf_file conf_file\n" unless $conf_file;

my $conf = LoadFile( $conf_file );

#my $github = Net::HTTP::Spore->new_from_spec(
#    $conf->{ github }->{ spec },
##    base_url => $conf->{ github }->{ base_url },
#);
#$github->enable( 'Format::JSON' );

#my $res;
#try {
#    $res = $github->user_search( format => 'json', search => 'franckcuny' );
#    say Dump $res;
#}
#catch {
#    warn Dump $_;
#};

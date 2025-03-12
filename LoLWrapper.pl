

use Cwd qw( abs_path );
use File::Basename qw ( dirname );
require("./op.pl");

sub read_config {
    my $region;
    my $summoner_name;
    my $fn = 'config.txt';

    #needs in program update support
    if ( !-e $fn ) {
        open my $fh, ">", $fn;
        print "Looks like you don't have a config, let's make one now\n";
        print "Enter your region, ex : NA, EUW\n";
        $region = <STDIN>;
        chomp $region;
        print "Region set to -> $region\n";

        print "Enter your Summoner Name\n";
        $summoner_name = <STDIN>;
        chomp $summoner_name;
        print "Summoner name set to $summoner_name\n";

        my $cd = dirname( abs_path($0) );
        print "Saving to config in current directory $cd\n";

        print $fh "$region\n";
        print $fh "$summoner_name\n";
        close $fh;
    }
    else {
        open my $fh, '<', $fn
          or die "Failed to open file, is it currently open?";
        print "Reading Config\n";
        chomp( my @config = <$fh> );
        $region        = $config[0];
        $summoner_name = $config[1];
        print "Found -> Region: $region , Summoner Name : $summoner_name\n";
        close $fh;
    }
    return ( \$region, \$summoner_name );
}

sub init_prog {
    my ( $region, $summoner_name ) = read_config();
    init_crawler( $region, $summoner_name );
    my $content  = get_userpage();
    my $ref = enumerate_summoners();
    process_userpages($ref);
}

init_prog();

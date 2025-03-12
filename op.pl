use WWW::Mechanize;
use Switch;

my $m = WWW::Mechanize->new();
my $BASE_URL;
my $global_summoner;

sub init_crawler {
    my ( $region, $summoner_name ) = @_;
    $$summoner_name =~ s/\s/%20/g;
    switch ( lc $$region ) {
        case "na" {
            $BASE_URL =
              "https://na.op.gg/summoner/spectator/userName=$$summoner_name"
        }
        case "euw" {
            $BASE_URL = "euw.na.gg/summoner/spectator/userName=$$summoner_name"
        }
        case "eune" {
            $BASE_URL =
              "eune.op.gg/summoner/spectator/userName=$$summoner_name"
        }
        else { print "Region not found" }
    }
    print "$BASE_URL\n";
    $global_summoner = $$summoner_name;
    return;
}

sub get_userpage {
    $m->get($BASE_URL);
    return $m->content;
}

sub enumerate_summoners {
    my $content = $m->content;

    #remove newlines
    $content =~ s/\R//g;

    #Regex for summoner pages, based on summonername cell
    my %summoner_info;
    while ( $content =~
/"SummonerName Cell">.{0,20}\/\/(\w+\.op\.gg\/summoner\/userName=(\w+))/ig
      )
    {
        $summoner_info{$1} = $2 unless $1 =~ /$global_summoner/i;
    }
    return \%summoner_info;
}

sub process_userpages {
    my %summoner_info = %{ $_[0] };
    my %key_search    = reverse %summoner_info;
    foreach my $key ( keys %summoner_info ) {
        my $base = 'https://';
        $base .= $key;
        $m->get($base);
        my $content = $m->content;
        $content =~ s/\R//g;

        #only latin support, selects summoner name in recently played box
        while ( $content =~ /SummonerName Cell">.{0,125}">([a-z0-9 ]+)<\/a>/ig )
        {
            my $name = lc($1);
            if ( exists $key_search{$name} ) {
                print "$summoner_info{$key} is playing with $1\n";
            }
        }
    }
    return 1;
}
1;

    #!/usr/bin/perl -w

    use strict;
    use WWW::Mechanize;

    my $start = "http://www.stevemcconnell.com/cc2/cc.htm";

    my $mech = WWW::Mechanize->new( autocheck => 1 );
    $mech->get( $start );

    my @links = $mech->find_all_links( url_regex => qr/\d+.+\.pdf$/ );

    for my $link ( @links ) {
        my $url = $link->url_abs;
        my $filename = $url;
        $filename =~ s[^.+/][];

        print "Fetching $url";
        $mech->get( $url, ':content_file' => $filename );

        print "   ", -s $filename, " bytes\n";
            }

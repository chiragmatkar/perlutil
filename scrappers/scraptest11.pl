    use strict; 
    $|++;

    use WWW::Mechanize;
    use File::Basename;

    my $m = WWW::Mechanize->new;

    $m->get("http://www.despair.com/indem.html");

    my @top_links = @{$m->links};

    for my $top_link_num (0..$#top_links) {
        next unless $top_links[$top_link_num][0] =~ /^http:/;

        $m->follow_link( n=>$top_link_num ) or die "can't follow $top_link_num";

        print $m->uri, "\n";
        for my $image (grep m{^http://store4}, map $_->[0], @{$m->links}) { 
            my $local = basename $image;
            print " $image...", $m->mirror($image, $local)->message, "\n"
        }

        $m->back or die "can't go back";
            }

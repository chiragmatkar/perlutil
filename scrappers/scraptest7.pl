    #!/usr/bin/perl -w
    
    use strict;
    
    use WWW::Mechanize;
    use Getopt::Long;
    use Text::Wrap;
    
    my $match = undef;
    my $random = undef;
    GetOptions(
        "match=s" => \$match,
        "random" => \$random,
    ) or exit 1;

    my $movie = shift @ARGV or die "Must specify a movie\n";

    my $quotes_page = get_quotes_page( $movie );
    my @quotes = extract_quotes( $quotes_page );

    if ( $match ) {
        $match = quotemeta($match);
        @quotes = grep /$match/i, @quotes;
    }

    if ( $random ) {
        print $quotes[rand @quotes];
    }
    else {
        print join( "\n", @quotes );
    }

    sub get_quotes_page {
        my $movie = shift;

        my $mech = WWW::Mechanize->new;
        $mech->get( "http://www.imdb.com/search" );
        $mech->success or die "Can't get the search page";

        $mech->submit_form(
            form_number => 2,
            fields => {
                title   => $movie,
                restrict    => "Movies only",
            },
        );

        my @links = $mech->find_all_links( url_regex => qr[^/Title] )
            or die "No matches for \"$movie\" were found.\n";

        # Use the first link
        my ( $url, $title ) = @{$links[0]};

        warn "Checking $title...\n";

        $mech->get( $url );
        my $link = $mech->find_link( text_regex => qr/Memorable Quotes/i )
            or die qq{"$title" has no quotes in IMDB!\n};

        warn "Fetching quotes...\n\n";
        $mech->get( $link->[0] );

        return $mech->content;
            }

    sub extract_quotes {
        my $page = shift;

        # Nibble away at the unwanted HTML at the beginnning...
        $page =~ s/.+Memorable Quotes//si;
        $page =~ s/.+?(<a name)/$1/si;

        # ... and the end of the page
        $page =~ s/Browse titles in the movie quotes.+$//si;
        $page =~ s/<p.+$//g;

        # Quotes separated by an <HR> tag
        my @quotes = split( /<hr.+?>/, $page );

        for my $quote ( @quotes ) {
            my @lines = split( /<br>/, $quote );
            for ( @lines ) {
                s/<[^>]+>//g;   # Strip HTML tags
                s/\s+/ /g;          # Squash whitespace
                s/^ //;     # Strip leading space
                s/ $//;     # Strip trailing space
                s/&#34;/"/g;    # Replace HTML entity quotes

                # Word-wrap to fit in 72 columns
                $Text::Wrap::columns = 72;
                $_ = wrap( '', '    ', $_ );
                            }
                            $quote = join( "\n", @lines );
                        }

        return @quotes;
            }

    #!/usr/bin/perl -w

    use WWW::Mechanize;
    use Storable;

    $url = 'http://www.census.gov/population/www/documentation/twps0027.html';
    $m = WWW::Mechanize->new();
    $m->get($url);

    $c = $m->content;

    $c =~ m{<A NAME=.tabA.>(.*?)</TABLE>}s
      or die "Can't find the population table\n";
    $t = $1;
    @outer = $t =~ m{<TR.*?>(.*?)</TR>}gs;
    shift @outer;
    foreach $r (@outer) {
      @bits = $r =~ m{<TD.*?>(.*?)</TD>}gs;
      for ($x = 0; $x < @bits; $x++) {
        $b = $bits[$x];
        @v = split /\s*<BR>\s*/, $b;
        foreach (@v) { s/^\s+//; s/\s+$// }
        push @{$data[$x]}, @v;
      }
    }

    for ($y = 0; $y < @{$data[0]}; $y++) {
        $data{$data[1][$y]} = {
            NAME => $data[1][$y],
            RANK => $data[0][$y],
            POP  => comma_free($data[2][$y]),
            AREA => comma_free($data[3][$y]),
            DENS => comma_free($data[4][$y]),
        };
    }

    store(\%data, "cities.dat");

    sub comma_free {
      my $n = shift;
      $n =~ s/,//;
      return $n;
    }

plague_of_coffee

    #!/usr/bin/perl -w

    use WWW::Mechanize;
    use strict;
    use Storable;

    $SIG{__WARN__} = sub {} ;  # ssssssh

    my $Cities = retrieve("cities.dat");

    my $m = WWW::Mechanize->new();
    $m->get("http://local.yahoo.com/");

    my @cities = sort { $Cities->{$a}{RANK} <=> $Cities->{$b}{RANK} } keys %$Cities;
    foreach my $c ( @cities ) {
      my $fields = {
        'stx' => "starbucks",
        'csz' => $c,
      };

      my $r = $m->submit_form(form_number => 2,
                              fields => $fields);
      die "Couldn't submit form" unless $r->is_success;

      my $hits = number_of_hits($r);
      #  my $ppl  = sprintf("%d", 1000 * $Cities->{$c}{POP} / $hits);
      #  print "$c has $hits Starbucks.  That's one for every $ppl people.\n";
      my $density = sprintf("%.1f", $Cities->{$c}{AREA} / $hits);
      print "$c : $density\n";
          }

    sub number_of_hits {
      my $r = shift;
      my $c = $r->content;
      if ($c =~ m{\d+ out of <b>(\d+)</b> total results for}) {
        return $1;
      }
      if ($c =~ m{Sorry, no .*? found in or near}) {
        return 0;
      }
      if ($c =~ m{Your search matched multiple cities}) {
        warn "Your search matched multiple cities\n";
        return 0;
      }
      if ($c =~ m{Sorry we couldn.t find that location}) {
        warn "No cities\n";
        return 0;
      }
      if ($c =~ m{Could not find.*?, showing results for}) {
        warn "No matches\n";
        return 0;
      }
      die "Unknown response\n$c\n";
    }

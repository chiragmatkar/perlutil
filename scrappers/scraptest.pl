 #!/usr/bin/perl -w
     use strict;
      $|++;
     
     ## user configurable parts
      
     my $BASEDIR = "/home/merlyn/Yahoo-news-images";
   
#      my $SEARCHES = <<'END';
 #    oregon oregon
  #          camel camel
  #         shania shania twain 
  #          END
            
            ## tinker parts
            
            my $INDEX = ".index";
            
            ## no servicable parts below
 use WWW::Mechanize 0.33;
use File::Basename;
            
 my $m = WWW::Mechanize->new;
 $m->quiet(1);                   # I'll handle my own errors, thank you
            
  for (grep !/^\#/, split /\n/, $SEARCHES) {
  my ($subdir, @keywords) = split;
            
  print "--- updating $subdir from a search for @keywords ---\n";
            
 $subdir = "$BASEDIR/$subdir" unless $subdir =~ m{^/};
  -d $subdir or mkdir $subdir, 0755 or die "Cannot mkdir $subdir: $!";
            
  dbmopen(my %seen, "$subdir/$INDEX", 0644) or die "cannot create index: $!";
            
 ##   clean any expired %seen tags
  {
   my $now = time;
   for (keys %seen) {
   delete $seen{$_} if $seen{$_} < $now;
       }
      }       
              $m->get("http://search.news.yahoo.com/search/news/options?p=";);
            
              $m->field("c", "news_photos");
              $m->field("p", "@keywords");
              $m->field("n", 100);
              $m->click();
            
              {
                print "looking at ", $m->uri, "\n";
                my @links = @{$m->extract_links};
            
                my @image_links = grep {
                  $links[$_][0] =~ m{^http://story\.news\.yahoo\.com/} and
                    $links[$_][1] eq "[IMG]";
                } 0..$#links;
            
                for my $image_link (@image_links) {
                  my $seen_key = "$links[$image_link][0]";
                  if ($seen{$seen_key}) {
                    print "  saw $seen_key\n";
                    next;
                  }
            
                  $m->follow($image_link);
            
                  print "  looking at ", $m->uri, "\n";
                  if (my ($image_url) = $m->res->content =~ m{<img src=(http:\S+) align=middle}) {
                    print "  mirroring $image_url... ";
                    my $response = $m->mirror($image_url, "$subdir/".basename($image_url));
                    print $response->message, "\n";
                    $seen{"$seen_key"} = time + 30 * 86400; # ignore for 30 days
                  }
            
                  $m->back;
                }
            
                redo if $m->follow(qr{next \d});
              }
            
            
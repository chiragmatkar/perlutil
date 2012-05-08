use LWP 5.64;
  my $url = 'http://www.pagepluscellular.com/dealers.aspx';   # Yes, HTTPS!
  my $browser = LWP::UserAgent->new;
  my $response = $browser->get($url);
  die "Error at $url\n ", $response->status_line, "\n Aborting"
   unless $response->is_success;
  print "Whee, it worked!  I got that ",
   $response->content_type, " document!\n";
#!/usr/bin/perl -w
use WWW::Mechanize;

# create agent
my $mech = WWW::Mechanize->new();

# Activate if  HTTP Proxy Enabled
$mech->proxy(['http'], 'http://10.10.48.148:800');

$mech->get("http://search.cpan.org");

if(! $mech->success) {
   print "Failed to load\n";
}


# Get all the links from the page that matches the given pattern.
my @links = $mech->find_all_links(url_regex => qr/modlist\/(.*)/);
foreach my $modlist (@links) {
 print("The URL is " . $modlist->url_abs . "\n");
}
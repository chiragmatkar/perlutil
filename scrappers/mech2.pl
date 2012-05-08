
use strict;
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();

# Enable HTTP Proxy 
$mech->proxy(['http', 'ftp'], 'http://10.10.48.148:800');
$mech->get("http://yahoo.com");

foreach ($mech->forms) { 		
		print $_->value,"\n" ; 		
	}

	
use WWW::Mechanize;
#use WWW::Mechanize::XML;
use XML::Simple;
#use HTML::TreeBuilder::XPath;
###use XML::LibXML;   Very important Requires libxml2 library from http://xmlsoft.org/ 
no warnings;

my $mech = WWW::Mechanize->new();
  
# Activate if  HTTP Proxy Enabled
$mech->proxy(['http'], 'http://10.10.48.148:800');

#get URL mech object
$mech->get('http://pagepluscellular.com/dealers.aspx');
#$mech->get("http://search.cpan.org");

# Select option Saudi Arabia
#$mech->set_visible( [ option => 'Saudi Arabia' ] );




# Get all the links from the page that matches the given pattern.
my @links = $mech->find_all_links(url_regex => qr/(.*\.aspx)/);

$i=0;
foreach my $each_url (@links) {
 print  $each_url->url_abs."\n";
 $mech->get($each_url);
		if($mech->success) {
		write_file($mech->content,"$file$i\.html");
		}else{
		next;
	   }
$i++;
 }

sub write_file{
	my ($data,$outfile)=@_;
	open(FH,">$outfile") or die "cannot create new file";
	print FH $data;
	close(FH);
}









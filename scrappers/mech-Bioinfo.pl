use WWW::Mechanize;   
my $mech = WWW::Mechanize->new();

# Activate if  HTTP Proxy Enabled
$mech->proxy(['http'], 'http://10.10.48.148:800');

$mech->get('http://rulai.cshl.edu/cgi-bin/SCPD/getgene2?ARG1'); 

$mech->set_fields( 'start' => -450, 'end' => 50 ); # this part works

# but not this:
$mech->click_button( 
        value  => "Retrieve sequence"
);

#$mech->submit();
print $mech->content();

$mech->save_content("gene.html");

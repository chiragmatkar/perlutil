use WWW::Mechanize;
my $mech = WWW::Mechanize->new();

# Enable HTTP Proxy 
$mech->proxy('http', 'http://10.10.48.148:800');

#get URL mech object
$mech->get('http://www.google.com');

my @links = $mech->find_all_links( url_regex => qr/https/);
	  for my $link ( @links ) {
       print $link->url_abs,"\n"; 
}
	  
#*********Submit Form*************    (Find Fields using mech-dumps,form_name/form_no)	  
#$mech->submit_form(
#        form_name => 'f',
#        fields    => { hidden  => 'pot of gold', },
#        button    => 'btnG'
#    );

#OR	
#$mech->form_number(1);
#$mecht->field("q", $queryString1);
#$mech->field("near", $queryString2);
#$mech->click("btnG");

# OR 
#$mech->form_with_fields('username');

# OR (Click button)
# $mech->click_button (value => "TAB");

# OR
# $mech->click_button({number => 1});  


#OR (Finer Control over Page fetching)
#
#$mech->find_link( n => $number );
#    $mech->form_number( $number );
 #   $mech->form_name( $name );
 #   $mech->field( $name, $value );
 #   $mech->set_fields( %field_values );
 #   $mech->set_visible( @criteria );
 #   $mech->click( $button );



#print $mech->content;

#********Save Image**********	
#$mech->get( 'photo.jpg' );
#$mech->save_content( 'D:\\photo.jpg' );


#$result=$mech->submit_form(
#       form_name => 'f',
#       fields    => { search => 'perl', },
#        button    => 'Google Search'
#    );
#	print $result->content;
	

# 
#$mech->follow_link( n => 3 );
#$mech->follow_link( text_regex => qr/download this/i );
#$mech->follow_link( url => 'http://host.com/index.html' );



# Submit form directly
#$mech->submit_form(
#       form_number => 3,
#       fields      => {
#           username    => 'mungo',
#           password    => 'lost-and-alone',
#        }
#   );
	
	
#Submit  form dirtectly 	
#   $mech->submit_form(
#       form_name => 'searchform',
#       fields    => { query  => 'pot of gold', },
#       button    => 'Search Now'
#    );


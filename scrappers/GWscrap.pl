#!/usr/bin/perl
use strict;
use WWW::Mechanize;
my $mech = WWW::Mechanize->new();

#Enable HTTP Proxy if any
$mech->proxy(['http'], 'http://10.10.48.148:800');

#Get URL mech object
$mech->get('http://groundwork.egain.net');

#print $mech->content;
eval{
    $agent->field('field_name', 'foo')
};
if($@){
   if($@ =~ /No such field/i){
      print "Field missing: field_name\n";
   }else{
      print "Something else is wrong\n";
   }
   
   
my @links = $mech->find_all_links( url_regex => qr/.*/ );
	  for my $link ( @links ) {
       print $link->url_abs,"\n"; 
}

#Submit Form Event	 
$mech->submit_form(
		form_name => 'usernamePasswordLoginForm',
		fields      => {
        josso_username    => 'cmatkar',
        josso_password    => 'bipasha@123',
        }
);
	
if($mech->success){
	print "Login Succesful";
}else{
	print "Cannot Login";
}




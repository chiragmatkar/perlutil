#!/usr/bin/perl --

use strict;
use warnings;

use WWW::Mechanize;
use URI::file;
my $ua = WWW::Mechanize->new();
$ua->timeout( 0.1 );
$ua->get( URI::file->new( __FILE__ ) );

$ua->add_handler("request_send",  sub { shift->dump; return });
$ua->add_handler("response_done", sub { shift->dump; return });

$ua->form_number(0);
$ua->submit;
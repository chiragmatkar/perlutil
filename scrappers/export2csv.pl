#!/usr/bin/perl
use strict;
use WWW::Mechanize;
use Archive::Tar;
use Mail::SendEasy;
use Data::Dumper;
use WWW::Mechanize;
use HTTP::Response;
use Text::CSV;

my $datadir = "C:\\incoming";
my $FileFragment = "Export*";

my $agent1 = WWW::Mechanize->new();
my $response = HTTP::Response->new();
$agent1 = WWW::Mechanize->new();
$agent1->get("https://samplesite.do");
$agent1->form_number(2);
$agent1->field("userName", "username");
$agent1->field("password", "password");
$agent1->click();

$agent1->follow_link(text => 'Download by date range');

$agent1->form_number(2);

my $fromDate = "08/01/2011";
my $toDate   = "08/31/2011";

print "From date $fromDate\n";
print "To date $toDate\n";
$agent1->field( "fromDate",$fromDate );
$agent1->field( "toDate",$toDate );
#$agent1->follow_link( url_regex => qr/Export to CSV/i );
$agent1->follow_link(text => 'Export to CSV'); 
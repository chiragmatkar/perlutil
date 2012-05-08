#!/usr/bin/perl -w
use strict;
use XML::Simple;
use LWP::Simple;
use Data::Dump::Streamer;

$|++;
my $ticker=['http://perlmonks.org/index.pl?node_id=30175&xmlstyle=rss',
            "http://rss.news.yahoo.com/rss/science"]->[rand 2];
print "Getting RSS from $ticker\n";
my $feed = get($ticker);
print "Parsing RSS...\n";
my $ref = XMLin($feed);
print "Dumping Parse Tree...\n";
Dump $ref;
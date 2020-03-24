#!/usr/bin/perl

use Term::ANSIColor qw(:constants);

#watch -n 5 'echo -n "sales-support-client:" ; curl --silent --insecure --user cgrau:421cb0b1b20be8e198f652c1767b4e4f https://accjenkins.server.lan/job/ACC.3201a-mobile-sales-support-client/lastBuild/api/json  | python -m json.tool | grep \"result\"; echo -n "access-java:         " ; curl --silent --insecure --user cgrau:421cb0b1b20be8e198f652c1767b4e4f https://accjenkins.server.lan/job/ACC.3201a-access-java/lastBuild/api/json  | python -m json.tool | grep \"result\"; echo -n "telesales-de:        " ; curl --silent --insecure --user cgrau:421cb0b1b20be8e198f652c1767b4e4f https://accjenkins.server.lan/job/ACC.3201a-telesales-de/lastBuild/api/json  | python -m json.tool | grep \"result\"';

use strict;

my $job=$ARGV[0];#'ACC.3201a-mobile-sales-support-client';
my $urlPrefix='https://accjenkins.server.lan/job/';
my $urlPostfix='/lastBuild/api/json';

my $url = $urlPrefix . $job . $urlPostfix;

my @curl=`curl --silent --insecure --user cgrau:421cb0b1b20be8e198f652c1767b4e4f $url | python -m json.tool`;
my ($result, $timestamp);
foreach my $line(@curl){
  #print "line:$line\n";
  $line =~ /\"result\":.*\"(.*)\"/ and $result=$1;#print $1 . "\t";
  $line =~ /\"timestamp\": ([0-9]+)/ and $timestamp = $1;
  #$line =~ /\"timestamp\": +([0-9])+[0-9]{3}/ and print $line;
}
$timestamp=substr($timestamp, 0, length($timestamp) - 3);
$timestamp=`date +'%F %T' -d \@$timestamp`;
chomp($result);
if($result =~ /SUCCESS/){
  print GREEN, "SUCCESS ", RESET;
} elsif (length($result) == 0){
  print BLUE, "BUILDING", RESET;
} else {
  print RED, "FAILED  ", RESET;
}
chomp($timestamp);
print " $timestamp $job\n";

#!/usr/bin/perl
use strict;

my @page=`lynx -dump https://www.farming-simulator.com/updates.php?lang=de\&country=de`;
my $gameFound = 0;
for(@page){
  if ( $gameFound || m/Landwirtschafts-Simulator 17/) {
    $gameFound = 1;
    if ( m/Update ([0-9]\.[0-9\.]+)/) {
      print $1;
      exit 0;
    }
  }
}
exit 1;

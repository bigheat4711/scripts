#!/usr/bin/perl
use strict;

my $line;
my $once = 1;
while($line = <>){
  next if $line =~ /^\W+$/;
  if($once == 1){
    $once = 0;
    $line =~ s/^/||/;
    $line =~ s/\t/||/g;
    $line =~ s/$/||/;
  } else {
    $line =~ s/^/|/g;
    $line =~ s/\t/|/g;
    $line =~ s/$/|/;
  }
  print $line;
}

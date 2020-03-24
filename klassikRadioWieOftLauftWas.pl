#!/usr/bin/perl
use strict;
use IPC::System::Simple qw(capture);

open(STORE, "<", "store.lst");

my %titleTimes;
while(<STORE>){
  next if $_ =~ /^\s+$/;
  my $titleAndCount = $_;
  chomp($titleAndCount);
  (my $title, my $count) = split('##', $titleAndCount);
  $titleTimes{$title} = $count;
}
close(STORE);

my $title;
my $lastTitle = "";
while(1){
  my @result = capture($^X, "klassikRadioWasLauftGerade.pl", ("chor"));
  print "\033[2J";    #clear the screen

  #extract title
  foreach my $resultLine (@result){
    if($resultLine =~ /Titel:(.*)/){
      $title = $1;
      $title =~ s/^\s+//;
      $title =~ s/\s+$//;
      print "Current song: $title\n";
      last;
    }
  }

  #if title changed
  if(($title cmp $lastTitle) != 0){
    $lastTitle = $title;
    if(exists $titleTimes{$title}){
      $titleTimes{$title}++;
    } else {
      $titleTimes{$title} = 1;
    }
  }
  print "$_ $titleTimes{$_}\n" for (keys %titleTimes);
 
  open(STORE, ">", "store.lst") or die "Can't write file store.lst\n";
  print STORE "$_##$titleTimes{$_}\n" for (keys %titleTimes);
  close(STORE);

  sleep 30;
}

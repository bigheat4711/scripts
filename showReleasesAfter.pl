#!/usr/bin/perl
use strict;
use DateTime;
use Term::ANSIColor qw(:constants);
use IPC::System::Simple qw(capture);

my $regExpEpisode = "^s([0-9]+)e([0-9]+)\$";
my $regExpDate = "^([0-9]{2})\\.([0-9]{2})\.([0-9]{4})\$";
my $persistentFile = "releases.lst";

($#ARGV != 1) and die "2 parameters are required. Parameters are
  #1: series (e.g. 'the-walking-dead'),
  #2: season (e.g. 'S05E03') OR date (e.g. '12.01.2015')\n";
my $series_in = $ARGV[0];#param series
my $searchfor = $ARGV[1];
$searchfor =~ /$regExpEpisode|$regExpDate/i or die "Parameter 2 in wrong format. Supported e.g. 'S05E03' or e.g. '12.01.2015'";
my $mode;
my $season_in, my $episode_in, my $date_in;
if($searchfor =~ /$regExpEpisode/i){
  $mode = 1;
  ($season_in, $episode_in) = ($1, $2);
  print "Looking for seasons after season $season_in episode $episode_in\n";
}
if($searchfor =~ /$regExpDate/){
  $mode = 2;
  (my $day_in, my $month_in, my $year_in) = ($1, $2, $3);
  print "Looking for seasons after date $day_in.$month_in.$year_in\n";
  $date_in = DateTime->new( year => $year_in, month => $month_in, day => $day_in);
}

#my %titleTimes;
#open(STORE, "<", $persistentFile);
#while(<STORE>){
  #next if $_ =~ /^\s+$/;
  #my $titleAndCount = $_;
  #chomp($titleAndCount);
  #(my $title, my $count) = split('##', $titleAndCount);
  #$titleTimes{$title} = $count;
#}
#close(STORE);

my @result = capture($^X, "fernsehserien.de.pl", $series_in);
foreach my $line (@result){
  #print $line;
  $line =~ /^([0-9]+)\s+([0-9]+)\.\s+([0-9]+)\s+(.)+([0-9]{2}\.[0-9]{2}\.[0-9]{4})/ or next;
  (my $nr, my $season, my $episode, my $title, my $date) = ($1, $2, $3, $4, $5);
  if($mode == 1){
      if($season > $season_in or ($season == $season_in and $episode > $episode_in)){
        print GREEN, $line, RESET;
    }
  }
    
  if($mode == 2){
      (my $day, my $month, my $year) = split('\.', $date);
      #print "Series date: " . ($day, $month, $year) . "\n";
      my $date = DateTime->new( year => $year, month => $month, day => $day);
      my $cmp = DateTime->compare($date, $date_in);
      if($cmp == 1){
        print GREEN, $line, RESET;
      }# else { print BLUE, "ignore\n", RESET; }
  }
  #print "\033[2J";    #clear the screen

  #print "$_ $titleTimes{$_}\n" for (keys %titleTimes);
 
  #open(STORE, ">", $persistentFile) or die "Can't write file $persistentFile\n";

  #print STORE "$_##$titleTimes{$_}\n" for (keys %titleTimes);
  #close(STORE);

}

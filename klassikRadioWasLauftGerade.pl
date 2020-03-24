#!/usr/bin/perl
use strict;

##steps of this programm are:
#validate input
#build url
#get website
#parse content

##validate input
my @supported = ("brazil", "chor", "christmas", "games", "klassikdreams", "live", "legenden_der_klassik", "lounge", "barock", "movie", "nature", "newclassics", "opera", "piano", "pure_bach", "pure_beethoven", "pure_mozart", "pure_verdi", "rockmeetsclassic", "schiller", "smooth");

if(! defined $ARGV[0]){
  print "Missing parameter. Allowed parameters are:\n";
  print join(', ', @supported) . "\n";
  exit(1);
}

my $channel=$ARGV[0];

my %map = map { $_ => 1 } @supported;
if(! exists($map{$channel})){
  print "Parameter is not valid. Allowed parameters are:\n";
  print join(', ', @supported) . "\n";
  exit(1);
}

##build url
my $filterChannel="filter[channel]=$channel";
my $filterDate   ="filter[date]=31.12.2017";
my $filterTime   ="filter[time]=00:00";
my $baseUrl="http://www.klassikradio.de/programm/was-lauft-gerade";
my $url = $baseUrl . '?' . $filterChannel . '&' . $filterDate . '&' . $filterTime;

##get website
my $cmd="links2 -dump '$url'";
#print $cmd;
my @content=`$cmd`;
#print @content;

##validate website
my $found=0;
foreach (@content){
  if(/Filter:/i){
    $found=1;
    last;
  }
}
if($found == 0){
  print "Schlüsselwort \"Filter:\" nicht gefunden\n";
  exit(1);
}

##parse content
my $line;
my $foundFilter = 0;
my $foundDate = 0;
my $foundTime = 0;
while(defined($line=shift(@content))){
  #exit(0) if($found && length($line) == 1);
  #print "line=$line";
  if($line=~/Filter/i){
    $foundFilter = 1;
    #print "FoundFilter\n";
  }
  if($foundFilter && $line=~/[0-3][0-9]\.[0-1][0-9]\.201[0-9]/i){
    $foundDate = 1;
    #print "FoundDate\n";
    #print "$line\n";
    #exit(0);
  }
  if($foundTime || ($foundFilter && $foundDate)){# && $line=~/[0-9][0-9]:[0-9][0-9]/)){
    $foundTime = 1;
    #$line =~ s/^\s+//g;
    print "$line";
    #exit(0);
  }
  if($foundTime &&   $line=~/Titel.*Big Lebowski/i){
    my $date = `date +%F-%H-%M-%S`;
    chomp($date);
    my $fileName = "$channel-" . $date . ".mp3";
    print "Start recording to file $fileName.\n";
    my @cmd=`timeout 360 vlc http://stream.klassikradio.de/$channel/mp3-128/www.klassikradio.de/ --sout $fileName`;
    #print "start to sleep...\n";
    print @cmd;
    `vlc $fileName`;
    exit(0); 
  }
  #if($foundTime && $line=~/\s+Weiter\s+/){
  if($foundTime && $line=~/\s+-->\s+/){
    last;
  }
}
exit(0);

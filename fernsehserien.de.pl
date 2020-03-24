#!/usr/bin/perl
use strict;
use feature qw(say);
use Term::ANSIColor qw(:constants);

my @supported = ("elementary", "die-simpsons", "how-to-get-away-with-murder");

if(! defined $ARGV[0]){
  print "Missing parameter. Use minus (-) instead of spaces ( ):\n";
  print join(', ', @supported) . "\n";
  exit(1);
}

my $serie=$ARGV[0];#$supported[2];

my @content= `w3m -dump -cols 180 http://www.fernsehserien.de/$serie/episodenguide`;
#print @content;

foreach (@content){
  #if(/nicht gefunden/i or /Fehler 404/i){
  if(/Fehler 404/i or /nicht gefunden/i){
    die "Serie $serie nicht gefunden\nSeite existiert nicht http://www.fernsehserien.de/$serie/episodenguide\n";
  }
}

my $line;
my $found;
#while(defined($line=shift(@content))){
foreach my $line (@content){
  chomp($line);
  #say $line;
  exit(0) if $found && $line =~ /Erinnerungs-Service per E-Mail/i;
  if($found || $line=~/^(\s){0,3}Staffel/){
    $found=1;
    #line has still data twice
    #print "$line\n";
    if($line=~/\d\d\.\d\d\.20\d\d/){
      #if line contains date
      #truncate line
      #print "found: $&\n";
      $line=substr($line, 0, $+[0]);
    }
    $line=~ s/^\s+//g;
    $line=~ s/\s+$//g;
    print $line . "\n";
  }
}

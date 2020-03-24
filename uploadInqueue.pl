#!/usr/bin/perl

use strict;

my $sourceDir=$ARGV[0];
die "Missing parameter source directory. Line: " if not -d $sourceDir;

my $targetDir=$ARGV[1];
die "Missing parameter target directory. Line:" if not -d $targetDir;

sub printFilesToMove{
  opendir(SRC, $sourceDir);
  my @inputFiles=sort grep {-f "$sourceDir/$_" } grep {$_ ne "." and $_ ne ".."} readdir SRC;
  print "Files to move:\n";
  print join "\n", @inputFiles;
  print "\n";
  closedir SRC;
  return @inputFiles;
}

sub isDropboxFinished(){
  #print $status;
  #my $found = $status =~ m/Up to date/;
  #print "$status";
}


my $currentFile;
while (1){
  my @inputFiles = printFilesToMove();
  my $status=`dropbox status`;
  print "$status";
  my $isFinished = $status =~ m/Up to date/;
  if($isFinished){
    #ready for next file
    print "Ready\n";
    $currentFile = shift @inputFiles;
    my $result = `mv $sourceDir/$currentFile $targetDir`;
    print $result;
    #print $currentFile;
  }
  `sleep 3s`;
  my $clear = `clear`;
  print $clear;
}


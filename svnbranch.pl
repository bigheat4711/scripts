#!/usr/bin/perl
#This script is private property of Claudio Grau

$argCnt=@ARGV;
($argCnt <= 1) or die "To many arguments. 0 or 1 allowed!\n";

$baseUrl=`svn info | grep "^URL:"`;
@baseUrl=split(/ /, $baseUrl);
$baseUrl=$baseUrl[1];

$pos=-1;
$pos == -1 and ($pos = index($baseUrl, "/trunk"));
$pos == -1 and ($pos = index($baseUrl, "/tags"));
$pos == -1 and ($pos = index($baseUrl, "/branches"));
$pos == -1 and die "SVN path must contain /trunk, /tags or /branches\n";

$baseUrl=substr($baseUrl, 0, $pos);

if($argCnt == 0){
  print "No argument passed -> list all available branches\n";
  $branches=`svn ls $baseUrl/branches`;
  print "$branches\n";
} else {
  $branch=$ARGV[0];
  @matches=`svn ls $baseUrl/branches | grep -i $branch`;
  if($#matches == -1){
    print "No matches for specified branch $branch\n";
    exit(1);
  } elsif($#matches > 0){
    print "Specified branch $branch was not unique:\n";
    print @matches;
    exit(1);
  } else{
    $branchMatched=$matches[0];
    print "Specified branch $branch was unique -> switching svn to branch $branchMatched\n";
    print `svn switch $baseUrl/branches/$branchMatched`;
  }
}

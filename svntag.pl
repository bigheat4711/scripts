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
  print "No argument passed -> list all available $tags\n";
  $tags=`svn ls $baseUrl/tags`;
  print "$tags\n";
} else {
  $tag=$ARGV[0];
  @matches=`svn ls $baseUrl/tags | grep -i $tag`;
  if($#matches == -1){
    print "No matches for specified tag $tag\n";
    exit(1);
  } elsif($#matches > 0){
    print "Specified tag $tag was not unique:\n";
    print @matches;
    exit(1);
  } else{
    $tagMatched=$matches[0];
    print "Specified tag $tag was unique -> switching svn to tag $tagMatched\n";
    print `svn switch $baseUrl/tags/$tagMatched`;
  }
}




print "\n";

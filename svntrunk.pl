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

$argCnt == 0 or die "No arguments allowed\n";
print "Switching to trunk\n";
print `svn switch $baseUrl/trunk`;

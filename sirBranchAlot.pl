#!/usr/bin/perl
use strict;
use Cwd;
use List::MoreUtils qw(uniq);
use feature qw(say);
use Term::ANSIColor qw(:constants);

my @filteredGroups=("mycompany");
print BLUE;
print "  ___ __ _ _ __ __ _ _   _ \n";
print " / __/ _` | '__/ _` | | | |\n";
print "| (_| (_| | | | (_| | |_| |\n";
print " \\___\\__, |_|  \\__,_|\\__,_|\n";
print "     |___/\n\n";
print RESET;

my $svnUrl=$ARGV[0];
print "svnUrl=$svnUrl\n";
my $branchName=$ARGV[1];
print "branchName=$branchName\n";

mkdir $branchName;
chdir $branchName;
#`svn co $svnUrl`;

my @result=split /\//, $svnUrl;
my $artifactName=$result[$#result];
print "artifactName=$artifactName\n";
chdir $artifactName;
#`svn cp trunk branches/$branchName`;
chdir "branches/$branchName";
#`mvn versions:set -DnewVersion=$branchName-SNAPSHOT`;
#`rm pom.xml.versionsBackup`;
#print getcwd;

###TODO change SCM
###TODO change shop.configservice.branch

#`mvn help:effective-pom -Doutput=effective.pom.xml`;

open EFF_POM, "< effective.pom.xml" or die "Can't find " . getcwd . "/effective.pom.xml\n";
my $startFound=0;
my ($g, $a, $v);
my @depGav=();#dependencies' GAV coordinates
while(<EFF_POM>){
  last unless not /<\/dependencies>/;
  next unless $startFound or /<dependencies>/;
  $startFound=1;
  #print;
  
  /<groupId>(.*)<\/groupId>/ and $g = $1;
  /<artifactId>(.*)<\/artifactId>/ and $a = $1;
  /<version>(.*)<\/version>/ and $v = $1;
  #defined $g and defined $a and defined $v and print "$g:$a:$v\n" and $g=$a=$v=();
  my $allFound=(defined $g and defined $a and defined $v);
  if($allFound){
   grep { $g =~ /.*$_.*/ } @filteredGroups and push @depGav, "$g:$a:$v";
   $g=$a=$v=();
  }
}
close EFF_POM;


sub offerDependenciesForSelection {
  my @depGav=@{$_[0]};
  for my $i (0 .. $#depGav){
    print "$i: " . $depGav[$i] . ":\n";
  }
  my $selection = <STDIN>;
  chomp $selection;
  print "selection=$selection\n";
  my @depSelectedIds = split / |,/, $selection;
  @depSelectedIds = uniq map { int($_) } @depSelectedIds;
  print "depSelectedIds:" . (join ',', @depSelectedIds) . "\n";
  my @newDepSelectedIds = grep { $_ >= 0 and $_ <= $#depGav } @depSelectedIds;
  print "WARNING: You entered some invalid indexes. They are ignored.\n" if $#newDepSelectedIds != $#depSelectedIds;
  @depSelectedIds = @newDepSelectedIds;
  print "depSelectedIds:" . (join ',', @depSelectedIds) . "\n";
  undef @newDepSelectedIds;
  
  @depGav = map { $depGav[$_] } @depSelectedIds;
  print "You selected: " . (join ", ", @depGav) . "\n";
  return @depGav;
}

print "Create more branches? Selection was filtered:\n";
my @gavToBranch = offerDependenciesForSelection(\@depGav);

print "Set  versions to $branchName? Selection was filtered:\n";
my @gavsToRaise = offerDependenciesForSelection(\@depGav);
push @gavsToRaise, @gavToBranch;
@gavsToRaise = uniq @gavsToRaise;

###
### Level 2: Change dependency versions
###
open POM, "< pom.xml" or die "Cant find POM " . getcwd . "/pom.xml\n";
chomp(my @pomLines = <POM>);
close POM;

my ($propsStart, $propsEnd, $depsStart, $depsEnd) = undef;
for my $i (0 .. $#pomLines){
  my $line = $pomLines[$i];
  #say $line;
  $line =~ /<properties>/ and $propsStart = $i;
  $line =~ /<\/properties>/ and $propsEnd = $i;
  $line =~ /<dependencies>/ and $depsStart = $i;
  $line =~ /<\/dependencies>/ and $depsEnd = $i;

  last if defined $propsEnd and defined $depsEnd;
}

say "propsStart=$propsStart" if defined $propsStart;
say "propsEnd=$propsEnd" if defined $propsEnd;
say "depsStart=$depsStart" if defined $depsStart;
say "depsEnd=$depsEnd" if defined $depsEnd;

sub gavOfInterest {
  #say "\@_=" . @_;
  my ($gavsToCheck_ref, $g, $a) = @_;
  #say "\$gavsToCheck_ref=$gavsToCheck_ref";
  #say "\$g=$g";
  #say "\$a=$a";
  
  #print "gavsToCheck: " . (join ',', @gavsToCheck);
  foreach my $gavToCheck (@$gavsToCheck_ref){
    my ($gToCheck, $aToCheck, $vToCheck) = split ':', $gavToCheck;
    next unless $g eq $gToCheck;
    next unless $a eq $aToCheck;
    return 1;
  }
}

## Level 2, Step 1: Change versions in <dependencies> block
my ($g, $a, $v) = undef;
my ($depStart, $indexVersion, $padding) = undef;
for my $i ($depsStart .. $depsEnd){
  my $line = $pomLines[$i];
  #say $line;

  $line =~ /<dependency>/ and defined $depStart and die "ohoh... GAV nicht vollständig, aber neue dependency beginnt bereits\n";
  $line =~ /<dependency>/ and $depStart = 1;
  $line =~ /<groupId>(.*)<\/groupId>/ and $g = $1;
  $line =~ /<artifactId>(.*)<\/artifactId>/ and $a = $1;
  $line =~ /(.*)<version>.*<\/version>/ and $padding = $1 and $indexVersion = $i;# and say RED, "version found in line $i", RESET;
  my $allFound=(defined $g and defined $a and defined $indexVersion);
  next unless $allFound;
  if(not gavOfInterest((\@gavsToRaise, $g, $a))) {
    #reset and next
    ($g,$a,$v,$depStart,$indexVersion) = ();
    next;
  }
  #next unless $allFound and gavOfInterest((\@gavsToRaise, $g, $a));
  #say GREEN, "replacing '$line' with '$branchName-SNAPSHOT' on line $indexVersion (0-based)", RESET;
  $pomLines[$indexVersion] = "$padding<version>$branchName-SNAPSHOT</version>";
  #reset and next
  ($g,$a,$v,$depStart,$indexVersion) = ();
  #say RED, "indexVersion=$indexVersion", RESET;
}

## Level 2, Step 2: Change versions in properties block - if required
#TODO

## Level 2, Step 3: Print new pom
open POM, "> pom.xml.new" or die "ERROR in __LINE__: Can't open pom.xml to write\n";
print POM join "\n", @pomLines;
close POM or die "ERROR in __LINE__: Can't close pom.xml\n";
exit;

###
### Determine SCM path of dependency
###

#print "Dependencies (GAV): " . (join ',', @depGav) . "\n";
my @depSvn=();
foreach (@gavToBranch) {
  chomp;
  print `mvn dependency:copy -Dartifact=$_:pom`;
  my $depPom="./target/dependency/another-app-1.0.1-SNAPSHOT.pom";#TODO this path shoudl not be static
  open DEP_POM, $depPom or die "Cant find file $depPom\n";
  while(<DEP_POM>){
    next unless /<connection>.*(http:.*)<\/connection>/ or /<connection>.*(file:.*)<\/connection>/;
    my $scm = $1;
    $scm =~ s/\/trunk//;
    push @depSvn, $scm;
    last;
  }
  close DEP_POM;
}

print getcwd . "\n";
chdir '../' x 4;
print getcwd . "\n";
print "\$0=$0\n";
print "\$ARGV[1]=$ARGV[1]\n";
print "\$^X=$^X\n";
#print system($^X, getcwd . '/' . $0, ($depSvn[0],$branchName));
#foreach my $scm (@depSvn){
#  print `svn co $scm`;
#}


###svn commit
###jenkins create job
###stool create stage
###./deploy-config.sh?!

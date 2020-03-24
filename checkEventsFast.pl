#!/usr/bin/perl

#use strict;
use Net::SSH::Perl;

my $output="/home/cgrau/EVENTS.lst";

#function printDate () {
  #date "+%F %T " | tr -d "\n" >> $output;
#}
my $cmd = "ls -l ~/slot4/configuration/platform.xml";
my $user = "jboss";
my $host = "accmobservbosstest01";
my $ssh = Net::SSH::Perl->new($host, "identity_files" => '/home/cgrau/.ssh/id_rsa' );
print "yuppie 2\n";
$ssh->login($user);
print "yuppie 3\n";
my ($out, $err, $exit) = $ssh->cmd($cmd);
print "out=$out\n";
print "err=$err\n";
print "exit=$exit\n";
my @out = (split(/ /, $out))[5..7];
print join(' ', @out) . "\n";
#$result=$(echo $result | cut -d' ' -f6-8)
#ignore="Nov 25 16:39"
#checkFileDate 


#if [ "$result" != "$ignore" ] ; then
#  printDate
#  text="value changed on host $host from $ignore to $result";
#  echo $text >> $output;
#  /usr/bin/zenity --info --title="checkEvents" --text="$text" --display=:0.0;
#fi

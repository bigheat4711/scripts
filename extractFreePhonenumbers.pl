#!/usr/bin/perl
#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use List::MoreUtils qw (uniq);
use File::Basename;

# Deklaration der noetigen Variablen fuer die Verbindung
# Falls die Datenbank nicht lokal liegt, muss man zusaetzlich
# die Variablen $db_host und/oder $db_port angeben
my $db_host = 'dbmy-mobile-services.db.server.lan';
my $db_port = 3306;

my $credentialsPath = dirname($0) . "/credentialsMobServ.properties";
open(CREDENTIALS, "<$credentialsPath") or die "Can't find file $credentialsPath (create this file containing 1st row user, 2nd row pass)!";
my $user = <CREDENTIALS>;
my $pw = <CREDENTIALS>;
close(CREDENTIALS);
chomp($user);
chomp($pw);
  
my ($db_user, $db_name, $db_pass) = ($user, 'simnumber', $pw);

# Verbindung zur DB herstellen
# alternativ ( wenn DB nicht lokal ):
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host;port=$db_port", "$db_user", "$db_pass");
# Man kann auch noch Fein-Tuning betreiben, z.B. mit dem RaiseError- oder dem AutoCommit-Switch.
# Naeheres dazu steht in der Dokumentation des Modules DBI.
#my $dbh = DBI->connect("DBI:mysql:database=$db_name", $db_user, $db_pass);

# Vorbereiten der SQL-Anweisung
my $prepare = $dbh->prepare(
'SELECT ndc, sn
FROM MobileNumber
WHERE true
AND state LIKE \'FREE\'
'
);

$prepare->execute() or die $prepare->err_str;
my @orderIds = ();

while (my ($ndc, $sn) = $prepare->fetchrow_array() ) {
    print $ndc, $sn, "\n";

    #open(FILE, ">$orderId\-$name.xml") or die "Can't open file\n";
    #print FILE $asString;
    #close(FILE);
    #push(@orderIds, $orderId);
    
}
#open(ORDER_IDS, ">orderIds.lst");
#my @filtered = uniq(@orderIds);
#print ORDER_IDS join("\n", @filtered);
#close(ORDER_IDS);

$dbh->disconnect();

package reduire_fantoir;
use strict;
use warnings;
use English qw( -no_match_vars );
use Carp qw(croak);

my $dh; #Directory handle
my $liste_communes = './liste_communes.txt'; #Liste des communes
my $fcommunes; #File handle fichier commune
my @fantoirs; #Liste des fichiers fantoir du r�pertoire courant
my $fant; #Fichier fantoir
my $ffant; #File handle fichier fantoir
my $out; #File handle fichier de sortie

opendir $dh, '.' or croak "Erreur $!";
@fantoirs = grep { /(fanr|fant)(?!.*reduit)/xi } readdir $dh;
if (@fantoirs != 1) {
	croak 'Fichier fantoir non trouv� (ou plusieurs trouv�s !)';
}
$fant = shift @fantoirs;
print "Fichier fantoir utilis� : $fant \n";

open $fcommunes, "<", $liste_communes or croak "Erreur $ERRNO";
open $ffant, "<", $fant or croak "Erreur $!";
open $out, ">", "./$fant".'_reduit' or croak "Erreur $ERRNO";

#Construire l'expression r�guli�re pour tester toutes les communes
my $regexp_communes = '';
while (my $commune = <$fcommunes>) {
	chomp($commune);
	$regexp_communes .= "^$commune.*|";
}
chop $regexp_communes; #Supprime le dernier caract�re '|'
close $fcommunes;
print "Expression r�guli�re : $regexp_communes\n\n";

while (my $ligne = <$ffant>) {
	if ($ligne =~ m/$regexp_communes/x) {
		print {$out} $ligne;
	}
}
close $ffant;
close $out;
print 'Appuyez sur entr�e...'; <STDIN>;

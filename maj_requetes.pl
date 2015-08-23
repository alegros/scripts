#Remplace des identifiants de th�mes dans les fichiers de requ�tes du
#r�pertoire indiqu� par $base apr�s en avoir cr��e une sauvegarde
use strict;
use warnings;
use File::Copy;
use File::Find;
use File::Path qw(make_path);
use Carp qw(croak);

my %remp = (
	'60' => '50'
);
my $base ='D:/travail/tmp/Requete';
my $sauv = $base . '_sauvegarde';

if (! -e $base) { exit; }
if (! -e $sauv) { mkdir $sauv; }

#Applique r�cursivement subst_idtheme � tous les fichiers de $base
find \&subst_idtheme, $base;
print 'Appuyez sur entr�e...'; <STDIN>;

sub subst_idtheme {
	my $ficnom = $File::Find::name;
	if (!(-f && $ficnom =~ m/\.req$/xm)) {
		#Pas un fichier de requ�te
		#Si r�pertoire, cr�er le r�pertoire de sauvegarde correspondant
		if (-d) {
			$ficnom =~ s/$base/$sauv/xm;
			make_path $ficnom;
		}
		return;
	}

	my $backup = $ficnom;
	$backup =~ s/$base/$sauv/x;
	if (! -e $backup) {
		copy $ficnom, $backup or croak "Copy failed : $!";
	}

	open my $in, '<', $backup or croak "Impossible d'ouvrir $backup : $!";
	open my $out, '>', $ficnom or croak "Impossible d'ouvrir $ficnom : $!";

	my $ligne;
	my $nbrep = 0; # Nombre de remplacement par fichier
	while ($ligne = <$in>) {
		if ($ligne =~ m/^themes.*/xsi) {
			foreach my $key (keys %remp) {
				$nbrep += $ligne =~ s/$key(\D)/$remp{$key}$1/xg;
			}
		}
		print {$out} $ligne;
	}
	print "$nbrep remplacement(s) dans $_ \n";
	close $in or croak "Impossible de fermer le fichier : $!";
	close $out or croak "Impossible de fermer le fichier : $!";
	return;
}

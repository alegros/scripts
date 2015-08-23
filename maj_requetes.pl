#Remplace des identifiants de thèmes dans les fichiers de requêtes du
#répertoire indiqué par $base après en avoir créée une sauvegarde
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

#Applique récursivement subst_idtheme à tous les fichiers de $base
find \&subst_idtheme, $base;
print 'Appuyez sur entrée...'; <STDIN>;

sub subst_idtheme {
	my $ficnom = $File::Find::name;
	if (!(-f && $ficnom =~ m/\.req$/xm)) {
		#Pas un fichier de requête
		#Si répertoire, créer le répertoire de sauvegarde correspondant
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

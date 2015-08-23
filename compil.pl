use strict;
use warnings;
use diagnostics;
use Data::Dumper;


sub copier_sql {
	my ($simulation, $version) = @_;
	my $sqlbase = 'E:/Controle/trunk/Dev/Src_dev/Oracle/';
	my $patchbase = 'T:/Developpement/Controle/trunk/Prod/Install/';
	my $short_src = $version.'/';
	my $short_dst = 'Patch'.$version.'/';
	my $src = $sqlbase.$short_src;
	my $dst = $patchbase.$short_dst;

	(-e $sqlbase && -e $patchbase && -e $src) or die "Répertoire(s) inexistant(s):\n" . join("\n",$sqlbase,$patchbase,$src);

	if (! -e $dst) {
		print "Création de $dst ...";
		mkdir $dst or die("Erreur lors de la création de $dst : $!");
	}

	my $dh;
	opendir $dh, $src or die("Erreur lors de l'accès à $src : $!");
	my @files = readdir $dh;

	@files = grep {$_ !~ m/^\./xm} @files; #Suppression des fichiers commençant par '.'
	print "Copie des sources sql...\n";
	foreach(@files) {
		my ($s, $d) = ($src.$_, $dst.$_);
		if (!$simulation && (! -e $d || (stat($s))[9] > (stat($d))[9])) {
			#$d non-existant ou date de modification antérieure à celle de $s
			copy $s, $d or die("!!!!!Erreur\nCopie de : $short_src$_\n    Vers : $short_dst$_\n$_\n\n");
		}
	}
}

sub compiler_client {
	my $simulation = shift @_;
	my $vb6exe = '"c:/Program Files/Microsoft Visual Studio/VB98/vb6.exe"';
	my $basedir = 'E:/Controle/trunk/Dev/';
	my $outdir = $basedir.'Executables/';
	my $out = $basedir.'Executables/LOG/';
	my $src = $basedir.'Src_dev/VB/';
	my @options = qw(/make /out /outdir /d); #Pour passer les options dans le bon ordre

	#Les clefs sont les noms des exe à générer
	my %projets = (
		'ApBarre_CONTROLE' => {
			'/make' => $src.'ApBarre/ApBarre.vbp',
			'/out' => $out.'ApBarre_CONTROLE.lst',
			'/outdir' => $outdir,
			'/d' => 'Lic_DLL=0:TYPE_DLL=0'
		},
		'CONTROLE_STAR' => {
			'/make' => $src.'Controle/Controle.vbp',
			'/out' => $out.'CONTROLE_STAR.lst',
			'/outdir' => $outdir,
			'/d' => 'Lic_DLL=0:TYPE_DLL=2'
		},
		'CONTROLE_SIG' => {
			'/make' => $src.'Controle/Controle.vbp',
			'/out' => $out.'CONTROLE_SIG.lst',
			'/outdir' => $outdir,
			'/d' => 'Lic_DLL=0:TYPE_DLL=0'
		},
		'CONTROLE_Param' => {
			'/make' => $src.'Controle_Param/Controle_Param.vbp',
			'/out' => $out.'CONTROLE_Param.lst',
			'/outdir' => $outdir,
			'/d' => 'Lic_DLL=0:TYPE_DLL=0'
		},
		'CONTROLE_GestionBase' => {
			'/make' => $src.'GestionBase/GestionBase.vbp',
			'/out' => $out.'CONTROLE_GestionBase.lst',
			'/outdir' => $outdir,
			'/d' => 'Lic_DLL=0:TYPE_DLL=0'
		}
	);

	foreach my $projet (keys %projets) {
		my @commande = ();
		print "Compilation de $projet...\n";
		foreach (@options) {
			push @commande, "$_ \"$projets{$projet}{$_}\"";
		}
		push @commande, "\"$projet\""; #Nom de l'exécutable produit
		if (not $simulation) {
			system($vb6exe, @commande) == 0 or print "!!!!! Échec $projet : $!";
		}
	}
}

sub main {
	my $simulation = '0';
	my $version = '5.9.0.0';

	print "\n\n", $simulation ? 'SIMULATION:':'', "Version $version\n";
	#copier_sql($simulation, $version);
	compiler_client($simulation);
	print $simulation ? "\n\nFin simulation\n\n":'';
}

main();
print "Appuyez sur entrée...";
<STDIN>;

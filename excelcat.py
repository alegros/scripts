# Concatène des fichiers excels en un fichier csv. Pas opérationnel, problème d'encodage
#AJOUTER ENTETE CSV
#Comparaison en-t?te de chaque fichier avec en-t?te par d?faut
#Traiter erreurs d'encodage : Supprimer et afficher les lignes fautives

import os
from os.path import normpath, join, isfile
import re
import xlrd
from xlrd.sheet import ctype_text
import csv

entree = './entree'
fichier_csv = './sortie/ads2007.csv'

def my_encode(str):
    return str.encode('windows-1252').strip()

def cell2text(cell):
    return my_encode(cell.value)

def cell2number(cell):
    return my_encode("{:f}".format(cell.value).rstrip('0').rstrip('.'))

def main():
    celltype_conversion = {'text': cell2text, 'number': cell2number}
    regexp = re.compile('.*\.xl.')
    fichiers = []

    for f in os.listdir(entree):
        if isfile(normpath(join(entree, f))) and regexp.match(f):
            fichiers.append(join(entree, f))
    print('\n'.join(fichiers))

    with open(fichier_csv, 'w') as csv_output:
        csv_writer = csv.writer(csv_output, delimiter=';', quotechar='"', quoting=csv.QUOTE_ALL, lineterminator='\n')
        for f in fichiers:
            xlbook = xlrd.open_workbook(f)
            feuille = xlbook.sheet_by_index(0)
            for numligne in range(1, feuille.nrows):
                # Applique une fonction de conversion sur chaque cellule en fonction de son type
                ligne = [celltype_conversion[ctype_text[cell.ctype]](cell) for cell in feuille.row(numligne)]
                print ligne[len(ligne)-2]
                csv_writer.writerow(ligne)
                print(ligne)

if __name__ == '__main__':
    main()

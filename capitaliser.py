import string

def main():
    com = ['BENAY'
,'BERTHENICOURT'
,'BRISSAY CHOIGNY'
,'BRISSY HAMEGICOURT'
,'CERIZY'
,'CHATILLON SUR OISE'
,'CHEVRESIS MONCEAU'
,'LA FERTE-CHEVRESIS'
,'GIBERCOURT'
,'LY FONTAINE'
,'MEZIERES SUR OISE'
,'PARPEVILLE'
,'PLEINE SELVE'
,'REGNY'
,'REMIGNY'
,'RENANSART'
,'SERY LES MEZIERES'
,'SISSY'
,'SURFONTAINE'
,'VENDEUIL'
,'VILLERS LE SEC']
    com.sort()
    for c in com:
        for mot in c.split(' '):
            mot = string.capitalize(mot) if len(mot) > 3 else mot.lower()
            print mot,

if __name__ == '__main__':
    main()

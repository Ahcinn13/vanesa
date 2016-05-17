# Tenis
**Projekt pri predmetu OPB, 2015/16**
![ER diagram](ERdiagram/ERdiagram.png)

###Viri:
* [Igralci (top 100)](http://www.tennis.com/rankings/ATP/)

* [Osebna statistika igralcev](http://www.tennisabstract.com/cgi-bin/leaders.cgi?f=E1s00o1)

* [Turnirji](http://www.tennisscores-stats.com/tournament-description.php)

* [Trenerji](http://www.atpworldtour.com/en/players/coaches)

###Uporaba
* Zaženi samo 'uvoz/uvoz_csv_tabel.R', torej source-aj to skripto direkt ali iz zadnje vrstice v 'projekt.R' in zloadale se bodo vse tabele.
* Na skupno bazo se še ne moreš povezati!

###Razlaga skript
* V skripti 'projekt.R' so skoraj vse skripte in kratke razlage za kaj se uporabijo / kaj zagnati. Tega raje ne sourceat

* 'uvoz/uvoz.R' vsebuje funkcije za uvozit tabele 'igralci', 'trenerji', 'stat_leto' (statistika po letih) in 'lokacije'

* 'uvoz/uvoz_h2h.R' nam uvozi tabelo 'h2h' ... Ne sourceaj, ker traja celo večnost!!!!

* 'uvoz_turnirji.R' nam uvozi tabelo 'turnirji'

* 'uvoz/uvoz_csv_tabel.R' nam uvozi vse tabele od prej, vendar iz '.csv' datotek, ki jih najdemo v 'podatki/csv' in smo jih ustvarili s skripto 'urejanje/ustvari_csv.R'. Tukaj je torej potrebno najprej te '.csv' datoteke ustvariti, ko pa že obstajajo, na ta način veliko hitreje vse uvozimo.

* 'urejanje/urejanje_igralci.R' nekoliko uredi tabelo 'igralci' ter doda njihove 'lastnosti' (višina, teža, ...)

* 'urejanje/urejanje_trenerji.R' uredi tabelo 'trenerji' ter ji doda manjkajoče vrednosti

* 'urejanje/ustvari_csv.R' iz že ustvarjenih tabel nam naredi '.csv' datoteke in jih shrani v 'podatki/csv'

* 'baza/baza.R' nam postavi bazo (briše, ustvarja tabele, ...)
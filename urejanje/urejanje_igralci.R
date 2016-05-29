# ### NASLEDNJA KODA JE NUJNA, ČE POGANJAŠ SAMO TO SKRIPTO
# ### ČE ZAGANJAMO 'projekt.R' LAHKO TO KODO ZAKOMENTIRAMO
# source('uvoz/uvoz.R', encoding='UTF-8')
# ########################################################

### Najprej odstranimo vse nepotrebne podatke
igralci <- igralci[, -2] # Odstranimo 2. stolpec (premikanje po lestvici)
igralci <- igralci[1:100, ] # Zožamo na TOP100 igralcev

# Popravimo imena, ki imajo 2 presledka namesto 1
igralci$Name[grepl('  ', igralci$Name)] <- gsub('  ', ' ', igralci$Name[grepl('  ', igralci$Name)])



### Sedaj pa dodajmo še manjkajočo statistiko (starost, višina, ...)

# Dodajmo stolpce v tabelo igralci, ki jih bomo nato zapolnili
igralci[, 5:12] <- ''

# Poimenujmo vse stolpce
colnames(igralci) <- c('Rank', 'Name', 'Country', 'Ranking_Points', 'Age', 'Height', 'Weight', 'Plays', 'Backhand', 'Turned_Pro', 'Career_Titles', 'Prize_Money_Earned')

# Funkcija, ki nam uvozi tabelo iz naslova
ustvari_tabelo <- function(naslov){
  tabela <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                          colClasses = c('character', 'character', 'character'))
}

# Funkcija, ki nam iz tabele iz naslova pobere in vrne željene podatke
poberi_iz_tabele <- function(naslov){
  tabela <- ustvari_tabelo(naslov)
  
  age <- c(substr(tabela[1,1], 1, 2), substr(tabela[1,3], 1, 2))
  height <- c(substr(tabela[4, 1], nchar(tabela[4, 1])-6, nchar(tabela[4, 1])-4),
              substr(tabela[4, 3], nchar(tabela[4, 3])-6, nchar(tabela[4, 3])-4))
  a <- 1 + c((nchar(tabela[5, 1]) == 16), (nchar(tabela[5, 3]) == 16))
  weight <- c(substr(tabela[5, 1], 10, 10+a[1]), substr(tabela[5, 3], 10, 10+a[2]))
  play <- c(tabela[6, 1], tabela[6, 3])
  backhand <- c(tabela[7, 1], tabela[7, 3])
  turned_pro <- c(tabela[8, 1], tabela[8, 3])
  titles <- c(tabela[12, 1], tabela[12, 3])
  money <- c(gsub(',', '', substr(tabela[13, 1], 2, nchar(tabela[13, 1]))),
             gsub(',', '', substr(tabela[13, 3], 2, nchar(tabela[13, 3]))))
  
  return(c(age, height, weight, play, backhand, turned_pro, titles, money))
}

# Dodajajmo sedaj igralcem manjkajoče vrednosti (dodajamo po parih, npr. (1, 2), (3, 4), ...)

igralci[match(c("Novak Djokovic", "Andy Murray"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/novak-djokovic-vs-andy-murray/D643/MC10')
igralci[match(c("Roger Federer", "Stanislas Wawrinka"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/roger-federer-vs-stan-wawrinka/F324/W367')
igralci[match(c("Rafael Nadal", "Kei Nishikori"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/rafael-nadal-vs-kei-nishikori/N409/N552')
igralci[match(c("Jo-Wilfried Tsonga", "Tomas Berdych"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/jo-wilfried-tsonga-vs-tomas-berdych/T786/BA47')
igralci[match(c("David Ferrer", "Richard Gasquet"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-ferrer-vs-richard-gasquet/F401/G628')
igralci[match(c("Milos Raonic", "Marin Cilic"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/milos-raonic-vs-marin-cilic/R975/C977')
igralci[match(c("David Goffin", "Gael Monfils"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-goffin-vs-gael-monfils/GB88/MC65')
igralci[match(c("Dominic Thiem", "John Isner"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/dominic-thiem-vs-john-isner/TB69/I186')
igralci[match(c("Roberto Bautista Agut", "Gilles Simon"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/roberto-bautista%20agut-vs-gilles-simon/BD06/SD32')
igralci[match(c("Kevin Anderson", "Nick Kyrgios"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/kevin-anderson-vs-nick-kyrgios/A678/KE17')
igralci[match(c("Benoit Paire", "Bernard Tomic"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/benoit-paire-vs-bernard-tomic/PD31/TA46')
igralci[match(c("Feliciano Lopez", "Viktor Troicki"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/feliciano-lopez-vs-viktor-troicki/L397/T840')
igralci[match(c("Pablo Cuevas", "Jack Sock"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/pablo-cuevas-vs-jack-sock/C882/SM25')
igralci[match(c("Philipp Kohlschreiber", "Alexandr Dolgopolov"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/philipp-kohlschreiber-vs-alexandr-dolgopolov/K435/D801')
igralci[match(c("Grigor Dimitrov", "Fabio Fognini"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/grigor-dimitrov-vs-fabio-fognini/D875/F510')
igralci[match(c("Ivo Karlovic", "Steve Johnson"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/ivo-karlovic-vs-steve-johnson/K336/J386')
igralci[match(c("Jeremy Chardy", "Joao Sousa"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/jeremy-chardy-vs-joao-sousa/CA12/SH90')
igralci[match(c("Thomaz Bellucci", "Federico Delbonis"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/thomaz-bellucci-vs-federico-delbonis/BD20/D874')
igralci[match(c("Sam Querrey", "Marcos Baghdatis"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/sam-querrey-vs-marcos-baghdatis/Q927/B837')
igralci[match(c("Andrey Kuznetsov", "Borna Coric"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/andrey-kuznetsov-vs-borna-coric/KB54/CG80')
igralci[match(c("Andreas Seppi", "Gilles Muller"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/andreas-seppi-vs-gilles-muller/SA93/MA30')
igralci[match(c("Guido Pella", "Martin Klizan"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/guido-pella-vs-martin-klizan/PC11/K966')
igralci[match(c("Vasek Pospisil", "Leonardo Mayer"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/vasek-pospisil-vs-leonardo-mayer/PD07/MD56')
igralci[match(c("Guillermo Garcia-Lopez", "Nicolas Mahut"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/guillermo-garcia-lopez-vs-nicolas-mahut/G476/M873')
igralci[match(c("Alexander Zverev", "Pablo Carreno Busta"), igralci$Name), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/alexander-zverev-vs-pablo-carreno%20busta/Z355/CD85')

#Zaželjeno bi bilo dodati še nekaj igralcev

igralci$Age <- sapply(igralci$Age, function(x) as.numeric(x))
igralci$Height <- sapply(igralci$Height, function(x) as.numeric(x))
igralci$Weight <- sapply(igralci$Weight, function(x) as.numeric(x))
igralci$Turned_Pro <- sapply(igralci$Turned_Pro, function(x) as.numeric(x))
igralci$Career_Titles <- sapply(igralci$Career_Titles, function(x) as.numeric(x))
igralci$Prize_Money_Earned <- sapply(igralci$Prize_Money_Earned, function(x) as.numeric(x))


igralci <- igralci[1:50, ] # Zožamo na TOP50 igralcev
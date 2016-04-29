# ### NASLEDNJA KODA JE NUJNA, ČE POGANJAŠ SAMO TO SKRIPTO
# ### ČE ZAGANJAMO 'projekt.R' LAHKO TO KODO ZAKOMENTIRAMO
# source('uvoz/uvoz.R', encoding='UTF-8')
# ########################################################

### Najprej odstranimo vse nepotrebne podatke
igralci <- igralci[, -2] # Odstranimo 2. stolpec (premikanje po lestvici)
igralci <- igralci[1:50, ] # Zožamo na TOP50 igralcev

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

igralci[c(1, 2), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/novak-djokovic-vs-andy-murray/D643/MC10')
igralci[c(3, 4), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/roger-federer-vs-stan-wawrinka/F324/W367')
igralci[c(5, 6), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/rafael-nadal-vs-kei-nishikori/N409/N552')
igralci[c(7, 8), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/jo-wilfried-tsonga-vs-tomas-berdych/T786/BA47')
igralci[c(9, 10), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-ferrer-vs-richard-gasquet/F401/G628')
igralci[c(11, 12), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/milos-raonic-vs-marin-cilic/R975/C977')
igralci[c(13, 14), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-goffin-vs-gael-monfils/GB88/MC65')
igralci[c(15, 16), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/dominic-thiem-vs-john-isner/TB69/I186')
igralci[c(17, 18), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/roberto-bautista%20agut-vs-gilles-simon/BD06/SD32')
igralci[c(19, 20), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/kevin-anderson-vs-nick-kyrgios/A678/KE17')
igralci[c(21, 22), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/benoit-paire-vs-bernard-tomic/PD31/TA46')
igralci[c(23, 24), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/feliciano-lopez-vs-viktor-troicki/L397/T840')
igralci[c(25, 26), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/pablo-cuevas-vs-jack-sock/C882/SM25')
igralci[c(27, 28), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/philipp-kohlschreiber-vs-alexandr-dolgopolov/K435/D801')
igralci[c(29, 30), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/grigor-dimitrov-vs-fabio-fognini/D875/F510')
igralci[c(31, 32), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/ivo-karlovic-vs-steve-johnson/K336/J386')
igralci[c(33, 34), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/jeremy-chardy-vs-joao-sousa/CA12/SH90')
igralci[c(35, 36), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/thomaz-bellucci-vs-federico-delbonis/BD20/D874')
igralci[c(37, 38), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/sam-querrey-vs-marcos-baghdatis/Q927/B837')
igralci[c(39, 40), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/andrey-kuznetsov-vs-borna-coric/KB54/CG80')
igralci[c(41, 42), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/andreas-seppi-vs-gilles-muller/SA93/MA30')
igralci[c(43, 44), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/guido-pella-vs-martin-klizan/PC11/K966')
igralci[c(45, 46), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/vasek-pospisil-vs-leonardo-mayer/PD07/MD56')
igralci[c(47, 48), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/guillermo-garcia-lopez-vs-nicolas-mahut/G476/M873')
igralci[c(49, 50), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/alexander-zverev-vs-pablo-carreno%20busta/Z355/CD85')

igralci$Age <- sapply(igralci$Age, function(x) as.numeric(x))
igralci$Height <- sapply(igralci$Height, function(x) as.numeric(x))
igralci$Weight <- sapply(igralci$Weight, function(x) as.numeric(x))
igralci$Turned_Pro <- sapply(igralci$Turned_Pro, function(x) as.numeric(x))
igralci$Career_Titles <- sapply(igralci$Career_Titles, function(x) as.numeric(x))
igralci$Prize_Money_Earned <- sapply(igralci$Prize_Money_Earned, function(x) as.numeric(x))
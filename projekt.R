# UVOZ TABEL
## Če nimamo že vse v .csv
source('uvoz/uvoz.R', encoding='UTF-8')
source('uvoz/uvoz_h2h.R', encoding='UTF-8')
source('uvoz/uvoz_turnirji.R', encoding='UTF-8')

# UREJANJE PODATKOV
source('urejanje/urejanje_igralci.R', encoding='UTF-8')
source('urejanje/urejanje_trenerji.R', encoding='UTF-8')

## Ustvari .csv datoteke
#source('urejanje/ustvari_csv', encoding='UTF-8')

# Če imamo .csv (da prihranimo čas, zgubimo prostor)
source('uvoz/uvoz_csv_tabel.R', encoding='UTF-8')

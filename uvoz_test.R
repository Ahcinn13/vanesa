### UVOZIMO PRVO TABELCO HIHI

uvoz.test <- function() {
  return(read.csv2("podatki/testna_tabela.csv", sep = ";", dec=",", skip = 2, as.is = TRUE, header=TRUE, 
                   na.strings="-",
                   col.names=c("leto", "m_indeks", "l_indeks", "avg_indeks"),
                   fileEncoding = "Windows-1250"))
}

a <- uvoz.test()
a <- a[1:303, ]


View(a)
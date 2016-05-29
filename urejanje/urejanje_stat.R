stat <- data.frame(stat[, 1], str_split_fixed(stat$Won_Loss, "-", 2), stat[, -c(1, 2, 8, 9)], str_split_fixed(stat$Tiebreak_WL, "-", 2), stat[, 9], stringsAsFactors = FALSE)

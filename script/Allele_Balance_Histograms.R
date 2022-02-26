#Allele Balance Histograms
#Script from O'Leary et. al. (2018), modified by Tyler DeVos
library(ggplot2)

AB_ratios1 <- read.table("AO_ratios/H_AC35.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios1$sample <- "PROBLEMATIC AB SAMPLE 1 - H_AC35"
AB_ratios2 <- read.table("AO_ratios/H_JJK1950.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios2$sample <- "PROBLEMATIC AB SAMPLE 2 - H_JJK1950"
AB_ratios3 <- read.table("AO_ratios/C_CRYO4393.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios3$sample <- "C_CRYO4393"
AB_ratios4 <- read.table("AO_ratios/C_CRYO4402.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios4$sample <- "C_CRYO4402"
AB_ratios5 <- read.table("AO_ratios/H_JJK1876.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios5$sample <- "H_JJK1876"
AB_ratios6 <- read.table("AO_ratios/H_MIA713.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios6$sample <- "H_MIA713"
AB_ratios7 <- read.table("AO_ratios/P_JJK2796.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios7$sample <- "P_JJK2796"
AB_ratios8 <- read.table("AO_ratios/P_JJK3070.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios8$sample <- "P_JJK3070"
AB_ratios9 <- read.table("AO_ratios/S_JBL4330.AO_ratio.txt", col.names = "AB", stringsAsFactors = FALSE)
AB_ratios9$sample <- "S_JBL4330"
AB_ratios <- rbind(AB_ratios1, AB_ratios2, AB_ratios3, AB_ratios4, AB_ratios5, AB_ratios6, AB_ratios7, AB_ratios8, AB_ratios9)
AB_ratios$sample <- factor(AB_ratios$sample, levels=c("PROBLEMATIC AB SAMPLE 1 - H_AC35", "PROBLEMATIC AB SAMPLE 2 - H_JJK1950", "C_CRYO4393", "C_CRYO4402", "H_JJK1876", "H_MIA713", "P_JJK2796", "P_JJK3070", "S_JBL4330"))

ggplot(AB_ratios, aes(x = AB)) +
  geom_histogram(binwidth = 0.02, color = "black", fill = "#F5BE41") +
  geom_vline(xintercept = 0.5, color = "#CF3721", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 0.2, color = "#375E97", linetype = "dotted", size = 1) +
  geom_vline(xintercept = 0.8, color = "#375E97", linetype = "dotted", size = 1) +
  labs(x = " ") +
  facet_wrap(~sample, nrow=3)

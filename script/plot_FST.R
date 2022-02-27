###Plot FST
#script provided by Dan Bock

#load the required library
library(ggplot2)
library(tidyverse)

#import data
carolinensis_hybrid <-read.delim(file="CH_FST.windowed.weir.fst", header = TRUE, sep='\t')
porcatus_hybrid <-read.delim(file="PH_FST.windowed.weir.fst", header = TRUE, sep='\t')
carolinensis_porcatus <-read.delim(file="CP_FST.windowed.weir.fst", header = TRUE, sep='\t')

#set base position numbers for plotting
nCHR <- length(unique(carolinensis_hybrid$CHROM))
carolinensis_hybrid$BPcum <- NA
s <- 0
nbp <- c()
for (i in unique(carolinensis_hybrid$CHROM)){
  nbp[i] <- max(carolinensis_hybrid[carolinensis_hybrid$CHROM == i,]$BIN_START)
  carolinensis_hybrid[carolinensis_hybrid$CHROM == i,"BPcum"] <- carolinensis_hybrid[carolinensis_hybrid$CHROM == i,"BIN_START"] + s
  s <- s + nbp[i]
}
axis.set <- carolinensis_hybrid %>% 
  group_by(CHROM) %>% 
  summarize(center = (max(BPcum) + min(BPcum)) / 2)
nCHR <- length(unique(porcatus_hybrid$CHROM))
porcatus_hybrid$BPcum <- NA
s <- 0
nbp <- c()
for (i in unique(porcatus_hybrid$CHROM)){
  nbp[i] <- max(porcatus_hybrid[porcatus_hybrid$CHROM == i,]$BIN_START)
  porcatus_hybrid[porcatus_hybrid$CHROM == i,"BPcum"] <- porcatus_hybrid[porcatus_hybrid$CHROM == i,"BIN_START"] + s
  s <- s + nbp[i]
}
axis.set <- porcatus_hybrid %>% 
  group_by(CHROM) %>% 
  summarize(center = (max(BPcum) + min(BPcum)) / 2)
nCHR <- length(unique(carolinensis_porcatus$CHROM))
carolinensis_porcatus$BPcum <- NA
s <- 0
nbp <- c()
for (i in unique(carolinensis_porcatus$CHROM)){
  nbp[i] <- max(carolinensis_porcatus[carolinensis_porcatus$CHROM == i,]$BIN_START)
  carolinensis_porcatus[carolinensis_porcatus$CHROM == i,"BPcum"] <- carolinensis_porcatus[carolinensis_porcatus$CHROM == i,"BIN_START"] + s
  s <- s + nbp[i]
}
axis.set <- carolinensis_porcatus %>% 
  group_by(CHROM) %>% 
  summarize(center = (max(BPcum) + min(BPcum)) / 2)

#remove unassigned scaffolds
carolinensis_hybrid <- subset(carolinensis_hybrid, grepl("^NC_", CHROM))
porcatus_hybrid <- subset(porcatus_hybrid, grepl("^NC_", CHROM))
carolinensis_porcatus <- subset(carolinensis_porcatus, grepl("^NC_", CHROM))

####plot FST for all three groups
ggplot(data = carolinensis_porcatus,aes(x = BPcum, y = WEIGHTED_FST, color=CHROM))+
  scale_color_manual(values = rep(c("#ADADAD","#CCCCCC"), 1000)) +
  geom_point(shape=1, size=0.2)+
  geom_point(data=carolinensis_hybrid, shape=1, size=0.2)+
  geom_point(data=porcatus_hybrid, shape=1, size=0.2)+
  geom_smooth(span=0.2,se = FALSE, color="black", size=0.5, method = "loess", linetype=2)+
  geom_smooth(data=carolinensis_hybrid, span=0.2,se = FALSE, color="#D49C2D", size=1, method = "loess")+
  geom_smooth(data=porcatus_hybrid, span=0.2,se = FALSE, color="#457772", size=1, method = "loess")+
  labs(x = NULL, y = "Weighted FST") +
  scale_x_continuous(breaks=c(128000000,360000000,565000000,745000000,900000000,1015000000,1069000000), labels=c("chr1","chr2","chr3","chr4","chr5","chr6","*")) +
  theme_bw()+
  theme( 
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())
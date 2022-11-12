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

####plot pairwise FST for all three groups
#carolinensis/porcatus/hybrid group 1
ggplot(data = carolinensis_porcatus,aes(x = BPcum, y = WEIGHTED_FST, color=CHROM))+
  geom_rect(xmin=0, xmax=263920458, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=263920458, xmax=463540353, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=463540353, xmax=667956763, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=667956763, xmax=824459207, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=824459207, xmax=975100780, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=975100780, xmax=1055842735, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=1055842735, xmax=1081644591, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_smooth(span=0.2,se = FALSE, color="black", size=0.5, method = "loess", linetype=2)+
  geom_smooth(data=carolinensis_hybrid1, span=0.2,se = FALSE, color="#D49C2D", size=1, method = "loess")+
  geom_smooth(data=porcatus_hybrid1, span=0.2,se = FALSE, color="#457772", size=1, method = "loess")+
  labs(x = NULL, y = "Weighted FST") +
  scale_x_continuous(breaks=c(128000000,360000000,565000000,745000000,900000000,1015000000,1069000000), labels=c("chr1","chr2","chr3","chr4","chr5","chr6","*")) +
  scale_y_continuous(breaks=seq(0,1,0.1), limits=c(0,1)) +
  ggtitle("Hybrid Group 1") +
  theme_bw()+
  theme(plot.title=element_text(face="bold", hjust=0.5),
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())

#carolinensis/porcatus/hybrid group 2
ggplot(data = carolinensis_porcatus,aes(x = BPcum, y = WEIGHTED_FST, color=CHROM))+
  geom_rect(xmin=0, xmax=263920458, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=263920458, xmax=463540353, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=463540353, xmax=667956763, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=667956763, xmax=824459207, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=824459207, xmax=975100780, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_rect(xmin=975100780, xmax=1055842735, ymin=0, ymax=1, fill="#CCCCCC", color=NA)+
  geom_rect(xmin=1055842735, xmax=1081644591, ymin=0, ymax=1, fill="#ADADAD", color=NA)+
  geom_smooth(span=0.2,se = FALSE, color="black", size=0.5, method = "loess", linetype=2)+
  geom_smooth(data=carolinensis_hybrid2, span=0.2,se = FALSE, color="#D49C2D", size=1, method = "loess")+
  geom_smooth(data=porcatus_hybrid2, span=0.2,se = FALSE, color="#457772", size=1, method = "loess")+
  labs(x = NULL, y = "Weighted FST") +
  scale_x_continuous(breaks=c(128000000,360000000,565000000,745000000,900000000,1015000000,1069000000), labels=c("chr1","chr2","chr3","chr4","chr5","chr6","*")) +
  scale_y_continuous(breaks=seq(0,1,0.1), limits=c(0,1)) +
  ggtitle("Hybrid Group 2") +
  theme_bw()+
  theme(plot.title=element_text(face="bold", hjust=0.5),
    legend.position = "none",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())

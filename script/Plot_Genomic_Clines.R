#GENOMIC CLINE ANALYSIS
library(ClineHelpR)
library(ggforce)
library(concaveman)

#import outlier data
outliers1 <- read.csv("~/Desktop/R_input/output/outliers1.csv")
outliers2 <- read.csv("~/Desktop/R_input/output/outliers2.csv")
outliers3 <- read.csv("~/Desktop/R_input/output/outliers3.csv")
outliers <- list(outliers1,outliers2,outliers3)

#Phi genomic cline plot
phiPlot(outlier.list=outliers, popname=paste0("Hybrid"), both.outlier.tests=TRUE, line.size=0.25, hist.y.origin=1.3, hist.height=1.8, margins=c(160.0,5.5,5.5,5.5), hist.binwidth=0.05)

#alpha-beta countour plot
alphaBetaPlot(outliers, both.outlier.tests=TRUE, alpha.color="cornflowerblue", beta.color="orange", neutral.color="gray60", padding=0, margins=c(40, 5.5,5.5,5.5))

#IDEOGRAM PLOTS
library(ggplot2)
library(ggrepel)
library(scales)

#Define chromosome names and sizes
chrom_sizes <- structure(list(V1=c("chr1","chr2","chr3","chr4","chr5","chr6","microA","microB","microC","microD","microF","microG","microH"), V2=c(263920458L, 199619895L,204416410L,156502444L,150641573L,80741955L,7025928L,3271537L,9478905L,1094478L,4257874L,424765L,248369L)), .Names=c("V1","V2"), class="data.frame", row.names=c(NA, -13L))
colnames(chrom_sizes) <- c("chromosome", "size")
chrom_order <- c("microH","microG","microF","microD","microC","microB","microA","chr6","chr5","chr4","chr3","chr2","chr1")
chrom_key <- setNames(object=as.character(c(1,2,3,4,5,6,7,8,9,10,11,12,13)), nm=chrom_order)
chrom_order <- factor(x=chrom_order, levels=rev(chrom_order))
chrom_sizes[["chromosome"]] <- factor(x=chrom_sizes[["chromosome"]], levels=chrom_order)

#Read in locus information from BGC script
loci.all <- outliers[[1]]

#Get rid of loci on unassigned (unmappable) scaffolds
loci <- subset(loci.all, grepl("^NC_", X.CHROM))

#Update chromosome names in locus table
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014776.1"] <- "chr1"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014777.1"] <- "chr2"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014778.1"] <- "chr3"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014779.1"] <- "chr4"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014780.1"] <- "chr5"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014781.1"] <- "chr6"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014782.1"] <- "microA"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014783.1"] <- "microB"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014784.1"] <- "microC"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014785.1"] <- "microD"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014786.1"] <- "microF"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014787.1"] <- "microG"
levels(loci$X.CHROM)[levels(loci$X.CHROM)=="NC_014788.1"] <- "microH"
loci[["X.CHROM"]] <- factor(x = loci[["X.CHROM"]], levels = chrom_order)

#Plot ideogram of alpha outliers
ggplot(data=chrom_sizes) +
  coord_flip() +
  theme(plot.title=element_text(hjust=0.5), axis.text.x=element_text(colour="black"),panel.grid.major=element_blank(), panel.grid.minor=element_blank(),panel.background=element_blank()) +
  scale_x_discrete(name="Chromosome", limits=names(chrom_key)) +
  scale_y_continuous(labels=comma) +
  ylab("SNP Position") +
  ggtitle("Ideogram of Alpha Outliers") +
  geom_rect(data = subset(loci, loci$alpha.outlier == "pos"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                  xmax = as.numeric(X.CHROM) + 0.2, 
                                                                  ymax = (POS+10000), ymin = (POS-10000)), fill="#D5A034", alpha=1) +
  geom_rect(data = subset(loci, loci$alpha.outlier == "neg"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                  xmax = as.numeric(X.CHROM) + 0.2, 
                                                                  ymax = (POS+10000), ymin = (POS-10000)), fill="#437570", alpha=1) +
  geom_rect(aes(xmin=as.numeric(chromosome)-0.2, xmax=as.numeric(chromosome) + 0.2, ymax=size, ymin=0), colour="black", fill="NA")

#Plot ideogram of beta outliers
ggplot(data=chrom_sizes) +
  coord_flip() +
  theme(plot.title=element_text(hjust=0.5), axis.text.x=element_text(colour="black"),panel.grid.major=element_blank(), panel.grid.minor=element_blank(),panel.background=element_blank()) +
  scale_x_discrete(name="Chromosome", limits=names(chrom_key)) +
  scale_y_continuous(labels=comma) +
  ylab("SNP Position") +
  ggtitle("Ideogram of Beta Outliers") +
  geom_rect(data = subset(loci, loci$beta.outlier == "pos"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                 xmax = as.numeric(X.CHROM) + 0.2, 
                                                                 ymax = (POS+100000), ymin = (POS-100000)), fill="red", alpha=1) +
  geom_rect(data = subset(loci, loci$beta.outlier == "neg"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                 xmax = as.numeric(X.CHROM) + 0.2, 
                                                                 ymax = (POS+10000), ymin = (POS-10000)), fill="#437570", alpha=1) +
  geom_rect(aes(xmin=as.numeric(chromosome)-0.2, xmax=as.numeric(chromosome) + 0.2, ymax=size, ymin=0), colour="black", fill="NA")

#Plot ideogram of loci that are both disproportionally represented and introgressing at a fast rate
ggplot(data=chrom_sizes) +
  coord_flip() +
  theme(plot.title=element_text(hjust=0.5), axis.text.x=element_text(colour="black"),panel.grid.major=element_blank(), panel.grid.minor=element_blank(),panel.background=element_blank()) +
  scale_x_discrete(name="Chromosome", limits=names(chrom_key)) +
  scale_y_continuous(labels=comma) +
  ylab("SNP Position") +
  ggtitle("Ideogram of Alpha Outliers Introgressing at a Faster than Expected Rate") +
  geom_rect(data = subset(loci, loci$beta.outlier == "neg" & loci$alpha.outlier == "neg"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                                               xmax = as.numeric(X.CHROM) + 0.2, 
                                                                                               ymax = (POS+10000), ymin = (POS-10000)), fill="#437570", alpha=1) +
  geom_rect(data = subset(loci, loci$beta.outlier == "neg" & loci$alpha.outlier == "pos"), aes(xmin = as.numeric(X.CHROM) - 0.2, 
                                                                                               xmax = as.numeric(X.CHROM) + 0.2, 
                                                                                               ymax = (POS+10000), ymin = (POS-10000)), fill="#D5A034", alpha=1) +
  geom_rect(aes(xmin=as.numeric(chromosome)-0.2, xmax=as.numeric(chromosome) + 0.2, ymax=size, ymin=0), colour="black", fill="NA")



##Bonus: isolate specific outlier sets (used counts to generate table 1)
#from whole genome
posalpha_all <- subset(outliers1, alpha.outlier=="pos")
negalpha_all <- subset(outliers1, alpha.outlier=="neg")
posbeta_all <- subset(outliers1, beta.outlier=="pos")
negbeta_all <- subset(outliers1, beta.outlier=="neg")
posa_negb_all <- subset(posalpha_all, beta.outlier=="neg")
nega_negb_all <- subset(negalpha_all, beta.outlier=="neg")
na_1 <- outliers1[is.na(outliers1$beta.outlier),]
na_all <- na_1[is.na(na_1$alpha.outlier),]
#excluding unassigned scaffolds
posalpha_some <- subset(loci, alpha.outlier=="pos")
negalpha_some <- subset(loci, alpha.outlier=="neg")
posbeta_some <- subset(loci, beta.outlier=="pos")
negbeta_some <- subset(loci, beta.outlier=="neg")
posa_negb_some <- subset(posalpha_some, beta.outlier=="neg")
nega_negb_some <- subset(negalpha_some, beta.outlier=="neg")
na_2 <- loci[is.na(loci$beta.outlier),]
na_some <- na_2[is.na(na_2$alpha.outlier),]

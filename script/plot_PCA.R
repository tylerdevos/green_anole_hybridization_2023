###PCA Plot
#script provided by Dan Bock

library(ggplot2)

##read in data files for all samples
#the input file was obtained using the "adegenet_PCA.R" script
pca_all<-read.csv(file="~/Desktop/10Ksubset.snp.results.csv",header = TRUE, sep = "")

#annotate sample groups
car1 <- rep("A. carolinensis",14)
hyb1 <- rep("hybrid",28)
car2 <- rep("A. carolinensis",2)
hyb2 <- rep("hybrid",42)
por <- rep("A. porcatus",15)
groups <- c(car1,hyb1,car2,hyb2,por)
pca_all$group <- groups

#partition samples by group
pca_all$group = factor(pca_all$group, levels=c("A. carolinensis", "hybrid", "A. porcatus"))

#PLOT PC1 PC2 for all samples
ggplot(pca_all, aes(PC1, PC2, colour=group))+
  geom_point()+
  theme_bw()+
  theme(axis.title=element_text(size=12), legend.title.align = 0.45, legend.text.align=0,
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())+
  #percent variance explained by each axis is calculated using the "adegenet_PCA.R" script
  xlab("\nPC1 (14.7%)")+
  ylab("PC2 (10.9%)\n")+
  scale_colour_manual(name="Group", labels = c(expression(italic("A. carolinensis")),"hybrid",expression(italic("A. porcatus"))), values = c("#D5A034","#749D58","#437570"))

#PLOT PC3 PC4 for all samples
ggplot(pca_all, aes(PC3, PC4, colour=group))+
  geom_point()+
  theme_bw()+
  theme(axis.title=element_text(size=12), legend.title.align = 0.57,
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())+
  labs(color="Group")+
  #percent variance explained by each axis is calculated using the "adegenet_PCA.R" script
  xlab("\nPC3 (2.2%)")+
  ylab("PC4 (1.8%)\n")+
  scale_colour_manual(name="Group", labels = c(expression(italic("A. carolinensis")),"hybrid",expression(italic("A. porcatus"))), values = c("#D5A034","#749D58","#437570"))

#PLOT PC5 PC6 for all samples
ggplot(pca_all, aes(PC5, PC6, colour=group))+
  geom_point()+
  theme_bw()+
  theme(axis.title=element_text(size=12), legend.title.align = 0.57,
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())+
  labs(color="Group")+
  #percent variance explained by each axis is calculated using the "adegenet_PCA.R" script
  xlab("\nPC5 (1.6%)")+
  ylab("PC6 (1.5%)\n")+
  scale_colour_manual(name="Group", labels = c(expression(italic("A. carolinensis")),"hybrid",expression(italic("A. porcatus"))), values = c("#D5A034","#749D58","#437570"))

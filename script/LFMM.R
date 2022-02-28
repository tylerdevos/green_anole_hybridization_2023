###LFMM for Environmental Association Analysis
#Useful explanation of concepts here: https://bookdown.org/hhwagner1/LandGenCourse_book/WE-11.html

library(LEA)
library(lfmm)
library(qvalue)

#convert VCF to LFMM format
setwd("~/Desktop/")
output = ped2lfmm("genotypes1.ped", force=TRUE)

#import data
genotypes<-read.delim(file="~/Desktop/R_input/genotypes.lfmm", header=FALSE, sep=" ")
environment<-read.delim(file="~/Desktop/R_input/environment.csv", header=TRUE, sep=",")
canopy <- environment
canopy$impervious <- NULL
impervious <- environment
impervious$canopy <- NULL

#modify these values to correspond to the number of loci on each chromosome in the dataset
chr1 <- rep("1",32648)
chr2 <- rep("2",25425)
chr3 <- rep("3",24787)
chr4 <- rep("4",20708)
chr5 <- rep("5",21028)
chr6 <- rep("6",11020)
micro <- rep("7",2432)
unassigned <- rep("8",84519)
chromosome <- c(chr1,chr2,chr3,chr4,chr5,chr6,micro,unassigned)

#View Principal Components to determine optimal K
pc <- prcomp(genotypes)
plot(pc$sdev[1:20]^2, xlab = 'PC', ylab = "Variance explained")
screeplot(pc, bstick=TRUE, type="barplot")

#LFMM for canopy cover
lfmm1 <- lfmm_ridge(Y=genotypes,X=canopy,K=2)
pv1 <- lfmm_test(Y=genotypes,X=canopy,lfmm=lfmm1,calibrate="gif")
pvalues1 <- pv1$calibrated.pvalue

#check genomic inflation factor (should be close to 1 if properly calibrated)
pv1$gif

#check effect of GIF adjustment on p-value distribution (should be flat with small peak at 0)
hist(pv1$pvalue[,1], main="Unadjusted p-values")        
hist(pv1$calibrated.pvalue[,1], main="GIF-adjusted p-values (GIF=1.11)")

#manually change GIF value
zscore <- pv1$score[,1]
new.gif <- 0.96
adj.pv1 <- pchisq(zscore^2/new.gif, df=1, lower = FALSE)
hist(adj.pv1, main="GIF-readjusted p-values (GIF=0.96)")

#qqplot of p value distribution
qqplot(rexp(length(adj.pv1), rate = log(10)),
       -log10(adj.pv1), xlab = "Expected quantile",
       pch = 19, cex = .4)
abline(0,1)

#convert p values to q values
qv1 <- qvalue(adj.pv1)$qvalues

#count number of SNPs with FDR less than 5%
length(which(qv1 < 0.05))

#list significant SNPs
fdr1 <- colnames(genotypes)[which(qv1 < 0.05)]
fdr1
qval1 <- as.data.frame(qv1)
Q1 <- subset(qval1, qv1 < 0.05)
Q1

#Manhattan plot
cand <- fdr1
cand <- sub('.', '', cand)
candidates <- as.numeric(cand)
palette(rep(c("#ADADAD","#CCCCCC"),4))
plot(-log10(adj.pv1), main="Group 1 Canopy Cover LFMM",xlab="SNP Position", ylab="-log(p)", pch = 19,cex = .2, col = chromosome) +
  points(candidates, -log10(adj.pv1)[candidates], col="red3")


#LFMM for impervious surface area
lfmm2 <- lfmm_ridge(Y=genotypes,X=impervious,K=2)
pv2 <- lfmm_test(Y=genotypes,X=impervious,lfmm=lfmm2,calibrate="gif")
pvalues2 <- pv2$calibrated.pvalue

#check genomic inflation factor (should be close to 1 if properly calibrated)
pv2$gif

#check effect of GIF adjustment on p-value distribution (should be flat with small peak at 0)
hist(pv2$pvalue[,1], main="Unadjusted p-values")        
hist(pv2$calibrated.pvalue[,1], main="GIF-adjusted p-values (GIF=0.94)")

#manually change GIF value
zscore <- pv2$score[,1]
new.gif <-  1.00
adj.pv2 <- pchisq(zscore^2/new.gif, df=1, lower = FALSE)
hist(adj.pv2, main="GIF-readjusted p-values (GIF=1.00)")
#qqplot of p value distribution
qqplot(rexp(length(adj.pv2), rate = log(10)),
       -log10(adj.pv2), xlab = "Expected quantile",
       pch = 19, cex = .4)
abline(0,1)

#convert p values to q values
qv2 <- qvalue(adj.pv2)$qvalues

#count number of SNPs with FDR less than 5%
length(which(qv2 < 0.05))

#list significant SNPs
fdr2 <- colnames(genotypes)[which(qv2 < 0.05)]
fdr2
qval2 <- as.data.frame(qv2)
Q2 <- subset(qval2, qv2 < 0.05)
Q2

#Manhattan plot
cand2 <- fdr2
cand2 <- sub('.', '', cand2)
candidates2 <- as.numeric(cand2)
palette(rep(c("#ADADAD","#CCCCCC"),4))
plot(-log10(adj.pv2), main="Group 1 Impervious Surface Area LFMM",xlab="SNP Position", ylab="-log(p)", pch = 19,cex = .2, col = chromosome) +
  points(candidates2, -log10(adj.pv2)[candidates2], col="red3")


##Bonus: histograms of environmental variables
ggplot(canopy, aes(x=canopy)) + geom_histogram(binwidth=5, color="white", fill="black") +
  xlab(label="Percent canopy cover") +
  ylab(label="Number of observations")
ggplot(impervious, aes(x=impervious)) + geom_histogram(binwidth=5, color="white", fill="black") +
  xlab(label="Percent impervious surface area") +
  ylab(label="Number of observations")
  
##Bonus: linear regression displaying correlation between canopy cover and impervious surface area
#Correlation coefficient
cor.test(environment$impervious, environment$canopy, method="pearson")
#linear regression model
fit <- lm(canopy ~ impervious, data = environment)
summary(fit)
#plot with 95% confidence intervals
newx <- seq(min(environment$impervious), max(environment$impervious), 0.1)
p <- predict(fit, newdata=data.frame(impervious=newx), interval = "confidence", level = 0.95, type="response")
plot(canopy ~ impervious, data = environment, main="Canopy Cover vs. Impervious Surface Area",
     xlab="Percent Impervious Surface Area", ylab="Percent Canopy Cover", pch=19)
abline(fit, col="red")
lines(newx, p[,2], col = "blue", lty=2)
lines(newx, p[,3], col = "blue", lty=2)

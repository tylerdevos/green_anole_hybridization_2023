####DAPC
#Activate packages
library(adegenet)
library(vcfR)

#Import and transform data
my_vcf <- read.vcfR("~/Desktop/10Ksubset_no_smaragdinus.vcf")
my_genind <- vcfR2genind(my_vcf)
strata<- read.table("~/Desktop/metadata.csv", header=FALSE, sep="")
strata_df <- data.frame(strata)
strata(my_genind) <- strata_df
setPop(my_genind) <- ~V2

#Identify clusters  
#For this step, all PCs should be retained. The lowest BIC value indicates the optimal k value.
grp <- find.clusters(my_genind, max.n.clust=8)

#View a table and plot of the cluster assignments  
table(pop(my_genind), grp$grp)
table.value(table(pop(my_genind), grp$grp), col.lab=paste("inf", 1:2), row.lab=paste("ori", 1:4))

#Perform discriminant analysis on the clusters identified by find.clusters  
#For this step, a moderate number of PCs and all discriminant functions should be retained
dapc1 <- dapc(my_genind, grp$grp)

#optimal alpha score determines how many PCs to retain
temp <- optim.a.score(dapc1)

#Plot groups
myCol <- c("gold","mediumpurple1","purple4","seagreen3")
scatter(dapc1, clab=0, col=myCol, scree.da=TRUE)
scatter(dapc1, 1,1, clab=0, col=myCol, scree.da=FALSE, leg=TRUE, txt.leg=c("carolinensis","hybrid 1","hybrid 2","porcatus"))
scatter(dapc1, 2,2, clab=0, col=myCol, scree.da=FALSE, leg=TRUE, posi.leg=("topleft"),txt.leg=c("carolinensis","hybrid 1","hybrid 2","porcatus"))

#Investigate admixed individuals
compoplot(dapc1, posi="bottomright", txt.leg=c("carolinensis","hybrid 1","hybrid 2","porcatus"),n.col=1,col=myCol)

#Plot and view the contribution of each locus to the discriminant function  
contrib <- loadingplot(dapc1$var.contr, axis=1, thres=.0005, lab.jitter=1)
contrib

#Perform discriminant analysis on the known population clusters
##For this step, a moderate number of PCs and all discriminant functions should be retained
setPop(my_genind) <- ~V2
dapc2 <- dapc(my_genind, pop(my_genind))

#optimal alpha score determines how many PCs to retain
temp <- optim.a.score(dapc2)

#Plot groups
myCol2=c("gold","mediumpurple3","seagreen3")
scatter(dapc2, clab=0, col=myCol2, scree.da=TRUE, leg=TRUE, txt.leg=c("carolinensis","hybrids","porcatus"))
scatter(dapc2, 1,1, clab=0, col=myCol2, scree.da=FALSE, leg=TRUE, txt.leg=c("carolinensis","hybrids","porcatus"))
scatter(dapc2, 2,2, clab=0, col=myCol2, scree.da=FALSE, leg=TRUE, posi.leg=("topleft"),txt.leg=c("carolinensis","hybrids","porcatus"))

#View reassignments (red=most likely assigned group) vs actual groups (blue +)
assignplot(dapc2)

#Investigate admixed individuals
compoplot(dapc2, posi="bottomright", txt.leg=c("carolinensis","hybrid","porcatus"),n.col=1,col=myCol2)

#Plot and view the contribution of each locus to the discriminant function
contrib <- loadingplot(dapc2$var.contr, axis=1, thres=.0005192, lab.jitter=1)
contrib
#View group level frequencies for a specific allele of interest
freq <- tab(genind2genpop(my_genind[loc=c("NC_014776_1_44312003")]),freq=TRUE)
matplot(freq, pch=c("A","B"), type="b",
        xlab="group",ylab="allele frequency", xaxt="n",
        cex=1.5, main="SNP NC_014776_1_44312003")


###EXTRA
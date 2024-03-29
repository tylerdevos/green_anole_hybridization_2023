####DAPC
#Activate packages
library(adegenet)
library(vcfR)

#Import and transform data
my_vcf <- read.vcfR("~/Desktop/10Ksubset.vcf")
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
myCol <- c("#D5A034","#B4CCA4","#749D58","#437570")
scatter(dapc1, clab=0, col=myCol, scree.da=TRUE)
scatter(dapc1, 1,1, clab=0, col=myCol, scree.da=FALSE, leg=FALSE, txt.leg=c(expression(italic("A. carolinensis")),"hybrid group 1","hybrid group 2",expression(italic("A. porcatus"))))
scatter(dapc1, 2,2, clab=0, col=myCol, scree.da=FALSE, leg=FALSE, posi.leg=("topleft"),txt.leg=c(expression(italic("A. carolinensis")),"hybrid group 1","hybrid group 2",expression(italic("A. porcatus"))))

#Investigate admixed individuals
compoplot(dapc1, posi="bottomright", txt.leg=c(expression(italic("A. carolinensis")),"hybrid group 1","hybrid group 2",expression(italic("A. porcatus"))),n.col=1,col=myCol)

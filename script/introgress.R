###INTROGRESS
#script from https://www.uwyo.edu/buerkle/software/introgress/
#ggplot triangle plot modification and custom version of ancestry plot source code by Tyler DeVos

library(introgress)

#read in data for individuals from admixed population
gen.data.sim <- read.csv(file="~/Desktop/introgress_input_fixed_admix", header=FALSE)

#read in marker information
loci.data.sim <- read.csv(file="~/Desktop/introgress_input_fixed_loci", header=TRUE)

#read in parental data sets
p1.data <- read.csv(file="~/Desktop/introgress_input_fixed_par1", header=FALSE)
p2.data <- read.csv(file="~/Desktop/introgress_input_fixed_par2", header=FALSE)

#code to convert genotype data into a matrix of allele counts
count.matrix.1 <- prepare.data(admix.gen=gen.data.sim, loci.data=loci.data.sim,
                             parental1=p1.data, parental2=p2.data, fixed=FALSE, pop.id=TRUE, ind.id=TRUE)

#estimate hybrid index values
hi.index.sim <- est.h(introgress.data=count.matrix.1, loci.data=loci.data.sim)

#make plot to visualize patterns of introgression
mk.image(introgress.data=count.matrix.1, loci.data=loci.data.sim, 
         hi.index=hi.index.sim, ylab.image="Individuals", main.image="Marker Ancestry Plot",
         xlab.h="carolinensis ancestry", pdf=FALSE)

#introgression plot source code with custom modifications
introgress.data <- count.matrix.1
loci.data <- loci.data.sim
marker.order <- NULL
hi.index <- hi.index.sim
ind.touse <- NULL
loci.touse <- NULL
ylab.image <- "Individuals"
main.image <- "Marker Ancestry Plot"
xlab.h <- "population 2 ancestry"
col.image <- NULL
#part 1
hi.index<-hi.index[,2]	
count.matrix<-introgress.data[[2]]
lg<-sort(unique(as.numeric(loci.data[,3])))
marker.n<-numeric(length(lg))
for(i in 1:length(lg)){
  marker.n[i] <- sum(loci.data[,3]==lg[i])}
loci.touse<-1:(dim(count.matrix)[1])
ind.touse<-1:(dim(count.matrix)[2])
col.image<-c("#A1D99B", "#41AB5D", "#005A32")
marker.order<-loci.touse
matrix <- count.matrix[marker.order, order(hi.index[ind.touse])]
    
nf <- layout(matrix(c(1,2),1,2,byrow=TRUE), c(6,1), c(1,1), respect=FALSE)  
par(mar=c(5,4,1,1))

image(x=loci.touse, y=ind.touse,
    z=matrix, col=col.image,
    breaks=c(-0.1,0.9,1.9,2.1), xlab="", ylab="",
    main=main.image, axes=FALSE)
abline(v=c(0, cumsum(marker.n)+0.5), col="lightgray", lwd=0.6)
box(lwd=3)
abline(v=2157.5, col="black", lwd=3)
abline(v=3627.5, col="black", lwd=3)
abline(v=5084.5, col="black", lwd=3)
abline(v=6190.5, col="black", lwd=3)
abline(v=6948.5, col="black", lwd=3)
abline(v=7261.5, col="black", lwd=3)
abline(v=7311.5, col="black", lwd=3)
axis(1, at=c(1079.5,2893,4356.5,5638,6570,7105.5,7287,8791), labels=c("chr.1","chr.2","chr.3","chr.4","chr.5","chr.6","*","unassigned scaffolds"), tick=FALSE, cex=0.5)
axis(1, at=c(0.5,2157.5,3627.5,5084.5,6190.5,6948.5,7261.5,7272.5,7280.5,7289.5,7310.5,7311.5,10269),labels=c("","","","","","","","","","","","",""),line=0.5)
axis(2, at=c(8,50,92.5), labels=c("porcatus\n(n=15)","hybrids\n(n=69)","carolinensis\n(n=16)"), tick=FALSE)
axis(2, at=c(0.5,15.5,84.5,100.5), labels=c("","","",""),line=0.5)

#part2
n.inds <- nrow(hi.index.sim)
plot(sort(hi.index[ind.touse]), 1:n.inds, axes=FALSE, xlab="", ylab="",
     ylim=c(1 + 0.0355 * n.inds, n.inds - 0.0355 * n.inds),
     cex=0.6, type="n", xlim=0:1)
mtext("Proportion", 1, line=3, cex=0.6)
mtext("carolinensis ancestry", 1, line=4, cex=0.6)
abline(v=0.5, col="lightgray")
lines(sort(hi.index[ind.touse]), 1:n.inds)
axis(1, at=c(0,0.5,1), cex.axis=0.6)
box()

#triangle plot
int.het.sim <- calc.intersp.het(introgress.data=count.matrix.1)
triangle.plot(hi.index=hi.index.sim, int.het=int.het.sim, pdf=FALSE)

#nicer triangle plot with ggplot
triangledata <- hi.index.sim
triangledata$het <- int.het.sim
triangledata$pop <- c("porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "porcatus", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid", "hybrid","hybrid","hybrid","hybrid","hybrid","hybrid","carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis", "carolinensis")
ggplot(triangledata, aes(h,het,color=pop,fill=pop))+
  geom_point(shape=21, alpha=0.75, size=3, color="black")+
  geom_segment(x=0,y=0,xend=0.5,yend=1,color="black",size=0.01)+
  geom_segment(x=0,y=0,xend=1,yend=0,color="black",size=0.01)+
  geom_segment(x=1,y=0,xend=0.5,yend=1,color="black",size=0.01)+
  labs(fill="Group")+
  scale_x_continuous(name="Hybrid Index", limits=c(0,1), breaks=seq(0,1, by=0.1))+
  scale_y_continuous(name="Interspecific Heterozygosity", limits=c(0,1), breaks=seq(0,1, by=0.1))+
  scale_fill_manual(values=c("gold","mediumpurple2","seagreen3"))+
  theme_bw()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

#conduct the genomic clines analysis
#this usese the permutation procedure with 1000 permutations
gen.out <- genomic.clines(introgress.data=count.matrix.1,
                          hi.index=hi.index.sim, loci.data=loci.data.sim,
                          sig.test=TRUE, method="parametric", het.cor=TRUE)

#make plots to visualize the genomic clines
#this saves the plots to a pdf in the current directory for R
clines.plot(cline.data=gen.out, rplots=3, cplots=3, pdf=TRUE, out.file="clines.pdf")
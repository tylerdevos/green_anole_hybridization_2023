###plot STRUCTURE results
#script provided by Dan Bock

library(pophelper)

#####plotting delta K Evanno method
setwd("~/Desktop/all_results_files/") #this folder contains 160 structure results files, one file for each K value and replicate (K1-20, 20 replicate runs each) 
sfiles<-c("Anolis_k1_run1_f","Anolis_k1_run2_f","Anolis_k1_run3_f","Anolis_k1_run4_f","Anolis_k1_run5_f","Anolis_k1_run6_f","Anolis_k1_run7_f",
          "Anolis_k1_run8_f","Anolis_k1_run9_f","Anolis_k1_run10_f","Anolis_k1_run11_f","Anolis_k1_run12_f","Anolis_k1_run13_f",
          "Anolis_k1_run14_f","Anolis_k1_run15_f","Anolis_k1_run16_f","Anolis_k1_run17_f","Anolis_k1_run18_f","Anolis_k1_run19_f","Anolis_k1_run20_f",
          "Anolis_k2_run1_f","Anolis_k2_run2_f","Anolis_k2_run3_f","Anolis_k2_run4_f","Anolis_k2_run5_f","Anolis_k2_run6_f","Anolis_k2_run7_f",
          "Anolis_k2_run8_f","Anolis_k2_run9_f","Anolis_k2_run10_f","Anolis_k2_run11_f","Anolis_k2_run12_f","Anolis_k2_run13_f",
          "Anolis_k2_run14_f","Anolis_k2_run15_f","Anolis_k2_run16_f","Anolis_k2_run17_f","Anolis_k2_run18_f","Anolis_k2_run19_f","Anolis_k2_run20_f",
          "Anolis_k3_run1_f","Anolis_k3_run2_f","Anolis_k3_run3_f","Anolis_k3_run4_f","Anolis_k3_run5_f","Anolis_k3_run6_f","Anolis_k3_run7_f",
          "Anolis_k3_run8_f","Anolis_k3_run9_f","Anolis_k3_run10_f","Anolis_k3_run11_f","Anolis_k3_run12_f","Anolis_k3_run13_f",
          "Anolis_k3_run14_f","Anolis_k3_run15_f","Anolis_k3_run16_f","Anolis_k3_run17_f","Anolis_k3_run18_f","Anolis_k3_run19_f","Anolis_k3_run20_f",
          "Anolis_k4_run1_f","Anolis_k4_run2_f","Anolis_k4_run3_f","Anolis_k4_run4_f","Anolis_k4_run5_f","Anolis_k4_run6_f","Anolis_k4_run7_f",
          "Anolis_k4_run8_f","Anolis_k4_run9_f","Anolis_k4_run10_f","Anolis_k4_run11_f","Anolis_k4_run12_f","Anolis_k4_run13_f",
          "Anolis_k4_run14_f","Anolis_k4_run15_f","Anolis_k4_run16_f","Anolis_k4_run17_f","Anolis_k4_run18_f","Anolis_k4_run19_f","Anolis_k4_run20_f",
          "Anolis_k5_run1_f","Anolis_k5_run2_f","Anolis_k5_run3_f","Anolis_k5_run4_f","Anolis_k5_run5_f","Anolis_k5_run6_f","Anolis_k5_run7_f",
          "Anolis_k5_run8_f","Anolis_k5_run9_f","Anolis_k5_run10_f","Anolis_k5_run11_f","Anolis_k5_run12_f","Anolis_k5_run13_f",
          "Anolis_k5_run14_f","Anolis_k5_run15_f","Anolis_k5_run16_f","Anolis_k5_run17_f","Anolis_k5_run18_f","Anolis_k5_run19_f","Anolis_k5_run20_f",
          "Anolis_k6_run1_f","Anolis_k6_run2_f","Anolis_k6_run3_f","Anolis_k6_run4_f","Anolis_k6_run5_f","Anolis_k6_run6_f","Anolis_k6_run7_f",
          "Anolis_k6_run8_f","Anolis_k6_run9_f","Anolis_k6_run10_f","Anolis_k6_run11_f","Anolis_k6_run12_f","Anolis_k6_run13_f",
          "Anolis_k6_run14_f","Anolis_k6_run15_f","Anolis_k6_run16_f","Anolis_k6_run17_f","Anolis_k6_run18_f","Anolis_k6_run19_f","Anolis_k6_run20_f",
          "Anolis_k7_run1_f","Anolis_k7_run2_f","Anolis_k7_run3_f","Anolis_k7_run4_f","Anolis_k7_run5_f","Anolis_k7_run6_f","Anolis_k7_run7_f",
          "Anolis_k7_run8_f","Anolis_k7_run9_f","Anolis_k7_run10_f","Anolis_k7_run11_f","Anolis_k7_run12_f","Anolis_k7_run13_f",
          "Anolis_k7_run14_f","Anolis_k7_run15_f","Anolis_k7_run16_f","Anolis_k7_run17_f","Anolis_k7_run18_f","Anolis_k7_run19_f","Anolis_k7_run20_f",
          "Anolis_k8_run1_f","Anolis_k8_run2_f","Anolis_k8_run3_f","Anolis_k8_run4_f","Anolis_k8_run5_f","Anolis_k8_run6_f","Anolis_k8_run7_f",
          "Anolis_k8_run8_f","Anolis_k8_run9_f","Anolis_k8_run10_f","Anolis_k8_run11_f","Anolis_k8_run12_f","Anolis_k8_run13_f",
          "Anolis_k8_run14_f","Anolis_k8_run15_f","Anolis_k8_run16_f","Anolis_k8_run17_f","Anolis_k8_run18_f","Anolis_k8_run19_f","Anolis_k8_run20_f")

#convert STRUCTURE run files to qlist
slist<-readQ(sfiles)

#tabulate the qlist
tr1 <- tabulateQ(qlist=slist)

#make a summary table from the tabulated dataframe
sr1 <- summariseQ(tr1)

#apply the Evanno method for inferring K and export pdf
evannoMethodStructure(data=sr1,exportplot=T,returnplot=F,returndata=F,imgtype="pdf",height=10, width=10,exportpath="../")


#####plotting STRUCTURE membership coefficients for K=2 and K=3
setwd("../membership_plots/") #this folder contains the structure results files to be used for plotting membership coefficients
#input files "Anolis_k2.ordered" and "Anolis_k3.ordered" were obtained using the "Reorder_Samples_STRUCTURE.sh" script

sfiles_K2<-c("Anolis_k2.ordered")
sfiles_K3<-c("Anolis_k3.ordered")

#convert STRUCTURE run files to qlist
slist_K2<-readQ(sfiles_K2)
slist_K3<-readQ(sfiles_K3)

#read in the metadata file, which contains two columns (individual ID, population ID)
labels<-read.csv(file="metadata.csv", header=FALSE, sep="")
labels$V2 <- as.character(labels$V2)

#keep only population IDs
onelabset <- labels[,2,drop=FALSE]

#plot results with ordered samples for K=2
plotQ(slist_K2[1],returnplot=F,exportplot=T,basesize=11,width=15,grplab=onelabset,grplabsize=1,imgtype="pdf",clustercol=c("seagreen3","gold"),exportpath="../")

#plot results with ordered samples for K=3
plotQ(slist_K3[1],returnplot=F,exportplot=T,basesize=11,width=15,grplab=onelabset,grplabsize=1,imgtype="pdf",clustercol=c("seagreen3","mediumpurple2","gold"),exportpath="../")

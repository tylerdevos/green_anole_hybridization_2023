library(ClineHelpR,quietly=T)
library(ggforce,quietly=T)
library(concaveman,quietly=T)

#combine the data files into one object (can also discard burnin samples here)
bgc_data <- combine_bgc_output(results.dir = "./", prefix="out", discard=50000)

#inspect parameter traces for convergence
plot_traces(df.list=bgc_data, prefix="out")

#identify alpha and beta outliers
outliers <- get_bgc_outliers(df.list=bgc_data, admix.pop="hybrid", popmap="./popmap", loci.file="./loci", qn=0.975)

#save outlier tables to working directory
outliers1 <- as.data.frame(outliers[1])
outliers2 <- as.data.frame(outliers[2])
outliers3 <- as.data.frame(outliers[3])
write.csv(outliers1, "./outliers1.csv", row.names=FALSE)
write.csv(outliers2, "./outliers2.csv", row.names=FALSE)
write.csv(outliers3, "./outliers3.csv", row.names=FALSE)

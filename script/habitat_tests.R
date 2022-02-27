###Habitat Tests

library(dplyr)
library(exactRankTests)
library(ade4)
library(vegan)

#import data
mantel_data <- read.csv("~/Desktop/mantel_data.csv")

#Wilcoxon rank-sum tests (used because data did not fit distributional requirements for t-test)
with(mantel_data, wilcox.exact(canopy~group))
with(mantel_data, wilcox.exact(impervious~group))

#Print group means
group1 <- subset(mantel_data, group=="1")
group2 <- subset(mantel_data, group=="2")
mean(group1$canopy)
mean(group2$canopy)
mean(group1$impervious)
mean(group2$impervious)

#Mantel tests
lizard.dists <- dist(cbind(mantel_data$long, mantel_data$lat))
canopy.dists <- dist(mantel_data$canopy)
impervious.dists <- dist(mantel_data$impervious)
group.dists <- dist(mantel_data$group)
mantel.rtest(lizard.dists, canopy.dists, nrepet = 1000)
mantel.rtest(lizard.dists, impervious.dists, nrepet = 1000)

#Partial Mantel tests
mantel.partial(group.dists, canopy.dists, lizard.dists, permutations = 1000)
mantel.partial(group.dists, impervious.dists, lizard.dists, permutations = 1000)

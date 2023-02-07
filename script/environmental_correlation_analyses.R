###Environmental correlation analyses

library(ggtext)
library(ggplot2)
library(spdep)
library(spatialreg)

#Import data
cor_data <- read.csv("~/Desktop/environmental_and_ancestry_data.csv")

#Basic correlation tests
cor.test(cor_data$porcatus_ancestry, cor_data$canopy, method="pearson")
cor.test(cor_data$porcatus_ancestry, cor_data$impervious, method="pearson")

#Basic linear regression
simple_canopy_model <- lm(porcatus_ancestry~canopy, data=cor_data)
summary(simple_canopy_model)
simple_impervious_model <- lm(porcatus_ancestry~impervious, data=cor_data)
summary(simple_impervious_model)

#Scatterplots with linear regression line and 95% confidence interval
ggplot(cor_data, aes(x=canopy, y=porcatus_ancestry)) +
  geom_point(pch=20, cex=2) +
  geom_smooth(method="lm", color="black", lwd=0.5, linetype="dashed") +
  scale_x_continuous(breaks=seq(0,100,10)) +
  scale_y_continuous(limits=c(0,1), breaks=seq(0,1,0.1)) +
  labs(y="*A. porcatus* ancestry proportion", x="Percent canopy cover") +
  ggtitle("Canopy Cover") +
  theme_minimal() +
  theme(plot.title=element_text(hjust=0.5), axis.line=element_line(), legend.position='none', panel.grid.major=element_blank(), panel.grid.minor=element_blank(), axis.title.y = ggtext::element_markdown())
ggplot(cor_data, aes(x=impervious, y=porcatus_ancestry)) +
  geom_point(pch=20, cex=2) +
  geom_smooth(method="lm", color="black", lwd=0.5, linetype="dashed") +
  scale_x_continuous(breaks=seq(0,100,10)) +
  scale_y_continuous(limits=c(0,1), breaks=seq(0,1,0.1)) +
  labs(y="*A. porcatus* ancestry proportion", x="Percent impervious surface area") +
  ggtitle("Impervious Surface Area") +
  theme_minimal() +
  theme(plot.title=element_text(hjust=0.5), axis.line=element_line(), legend.position='none', panel.grid.major=element_blank(), panel.grid.minor=element_blank(), axis.title.y = ggtext::element_markdown())

#Create spatial weights matrix from lat/long coordinates
xy <- cbind(cor_data$x, cor_data$y)
xy.1 <- knn2nb(knearneigh(xy))
xy_w <- nb2listw(xy.1)

#Moran's I test for spatial autocorrelation
canopy.moran <- lm.morantest(simple_canopy_model, xy_w)
print(canopy.moran)
impervious.moran <- lm.morantest(simple_impervious_model, xy_w)
print(impervious.moran)

#Lagrange multiplier diagnostic tests (can help decide whether to account for spatial autocorrelation with a spatial error model or a spatial lag model)
LM_canopy <- lm.LMtests(simple_canopy_model, xy_w, test="all")
LM_canopy
LM_impervious <- lm.LMtests(simple_impervious_model, xy_w, test="all")
LM_impervious

#Spatial lag models
canopy.lag <- lagsarlm(formula=porcatus_ancestry~canopy, data=cor_data, xy_w)
summary(canopy.lag)
impervious.lag <- lagsarlm(formula=porcatus_ancestry~impervious, data=cor_data, xy_w)
summary(impervious.lag)

#Calculate direct and indirect predictor effect estimates and corresponding p-values
canopy.impact <- impacts(canopy.lag, listw=xy_w, R=100)
canopy.impact.summary <- summary(canopy.impact, zstats=T)
data.frame(canopy.impact.summary$res)
data.frame(canopy.impact.summary$pzmat)
impervious.impact <- impacts(impervious.lag, listw=xy_w, R=100)
impervious.impact.summary <- summary(impervious.impact, zstats=T)
data.frame(impervious.impact.summary$res)
data.frame(impervious.impact.summary$pzmat)

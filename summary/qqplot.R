#!/usr/local/bin/Rscript

# NOTE: all paths in this file assume that it is being
# run from the root directory of this project

require("qualityTools") # for qqPlot
taps <- read.table("data/taps.tsv", header=TRUE, sep="\t")

# qq plot
pdf(file="summary/plots/qqnorm.pdf")
par(mfrow=c(2,2))
for(i in names(taps)){
  if(i == "pin" || i == "name") next;
  qqPlot(taps[,which(names(taps)==i)], "normal", 
         main=paste(i, "Q-Q plot", sep=" "),
         xlab=paste("Quantiles from", i, sep=" "),
         ylab="Quantiles from normal")
}
dev.off()

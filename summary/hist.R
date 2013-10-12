#!/usr/local/bin/Rscript

# NOTE: all paths in this file assume that it is being
# run from the root directory of this project

taps <- read.table("data/taps.tsv", header=TRUE, sep="\t")

# histograms
pdf(file="summary/plots/hist.pdf")
par(mfrow=c(3,3))
for(i in names(taps)){
  if(i == "pin" || i == "name") next;
  hist(taps[,which(names(taps)==i)], main=paste(i,"Histogram",sep=" ") , xlab=i)
}
dev.off()

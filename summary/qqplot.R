#!/usr/local/bin/Rscript

# NOTE: all paths in this file assume that it is being
# run from the root directory of this project

require("qualityTools") # for qqPlot
taps <- read.table("data/taps.tsv", header=TRUE, sep="\t")

# qq plot
pdf(file="summary/plots/qqnorm.pdf")
par(mfrow=c(2,2))
qqPlot(taps$duration_1,"normal")
#hist(taps$latency_1, "normal")
qqPlot(taps$latency_2, "normal")
qqPlot(taps$latency_2, "normal")
qqPlot(taps$latency_3, "normal")
qqPlot(taps$latency_4, "normal")
qqPlot(taps$latency_5, "normal")
qqPlot(taps$duration_1, "normal")
qqPlot(taps$duration_2, "normal")
qqPlot(taps$duration_3, "normal")
qqPlot(taps$duration_4, "normal")
qqPlot(taps$duration_5, "normal")
qqPlot(taps$size_1, "normal")
qqPlot(taps$size_2, "normal")
qqPlot(taps$size_3, "normal")
qqPlot(taps$size_4, "normal")
qqPlot(taps$size_5, "normal")
dev.off()

#!/usr/local/bin/Rscript

# NOTE: all paths in this file assume that it is being
# run from the root directory of this project

taps <- read.table("data/taps.tsv", header=TRUE, sep="\t")

# histograms
pdf(file="summary/plots/hist.pdf")
par(mfrow=c(3,5))
#hist(taps$latency_1, main="latency_1", xlab="latency")
hist(taps$latency_2, main="latency_2", xlab="latency")
hist(taps$latency_2, main="latency_2", xlab="latency")
hist(taps$latency_3, main="latency_3", xlab="latency")
hist(taps$latency_4, main="latency_4", xlab="latency")
hist(taps$latency_5, main="latency_5", xlab="latency")
hist(taps$duration_1, main="duration_1", xlab="duration")
hist(taps$duration_2, main="duration_2", xlab="duration")
hist(taps$duration_3, main="duration_3", xlab="duration")
hist(taps$duration_4, main="duration_4", xlab="duration")
hist(taps$duration_5, main="duration_5", xlab="duration")
hist(taps$size_1, main="size_1", xlab="size")
hist(taps$size_2, main="size_2", xlab="size")
hist(taps$size_3, main="size_3", xlab="size")
hist(taps$size_4, main="size_4", xlab="size")
hist(taps$size_5, main="size_5", xlab="size")
dev.off()

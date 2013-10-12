#!/usr/local/bin/Rscript

# NOTE: all paths in this file assume that it is being
# run from the root directory of this project

taps <- read.table("data/taps.tsv", header=TRUE, sep="\t")
str(taps)
summary(taps)

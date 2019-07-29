#################################### sparsebn ########################

rm(list=ls())
if(!require(sparsebn)) install.packages("sparsebn")
library(sparsebn)

print(paste(' The network we choose is the Child network and the sample size  is 100 '))

# loading data
randag<-read.csv("Child_s100.csv",header=FALSE)
#randag<-t(randag)

# true BN structure	
true_b<-read.table("Child_graph.txt",header=FALSE)

randag<-as.data.frame(randag)
randag<-randag-1

data<-sparsebnData(randag, type = "discrete")
cd<-estimate.dag(data)
cd

# Model selection
i<-select.parameter(cd,data)

b<-get.adjacency.matrix(cd[[i]])
b<-as.matrix(b)

TLE<-sum(b-true_b!=0)
TP<-sum(true_b)-sum(((true_b-b)==1))
FP<-sum(((true_b-b)==-1))

print(paste('FP= ', FP))

print(paste('TP= ', TP))

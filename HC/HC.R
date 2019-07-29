rm(list=ls())
print(paste(' The network we choose is the Child network and the sample size is 100 '))

if(!require(bnlearn)) install.packages("bnlearn")
library(bnlearn)

s_child<-read.csv("Child_s100.csv",header=FALSE)

true_b<-read.table("Child_graph.txt",header=FALSE) 

for(i in 1:dim(true_b)[1]){s_child[,i]<-factor(s_child[,i])}


bn.hc<-hc(s_child,score="aic")

a<-arcs(bn.hc)

b<-matrix(0,ncol=dim(true_b)[1],nrow=dim(true_b)[1])

for(i in 1:dim(a)[1])
{h<-lapply(strsplit(a[i,],'V'),as.integer)$from[2]
l<-lapply(strsplit(a[i,],'V'),as.integer)$to[2]
b[h,l]<-1
}
sum(b)

TLE<-sum(b-true_b!=0)
TP<-sum(true_b)-sum(((true_b-b)==1))
FP<-sum(((true_b-b)==-1))

print(paste('FP= ', FP))

print(paste('TP= ', TP))

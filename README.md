# MatLab and R codes for "A New Algorithm for Learning Large Bayesian Network Structure from Discrete Data" by Zhang W., Xu Z., Chen Y. and Yang J.

To demonstrate our SSLA algorithm and compare with other competitors, we give a brief description on the implementation of all algorithms. All the codes are tested on a laptop with Intel Core i5-8250U @ 1.60GHz and 8G RAM,  Windows 10 64-bit version, MatLab 2019a 64bit version and R version 3.6.0. Please note that we use the Windows x64 DLL(lbfgsC.mexw64) for SSLA algorithm, thus it can not run properly on linux type system.

The network we choose is the Child network, which has 20 nodes and 25 edges, and the sample size  is 100. (data file: Child_s100_v1.csv)

The outputs are similar to the results of Tables 3 and 4 in the paper. Please note that here we use a single data set, the outputs will be slightly different from the results in the paper, which is an average.

The following are examples for each program.

## SSLA algorithm
run main.m in the SSLA folder

Output:
FP= 3 
TP= 19 

## SSLA algorithm (when the order of the nodes is given)
run main0.m in the SSLA folder

Output:
FP= 5
TP=24 

## K2 algorithm
run main.m in the K2 folder
 

Output:
FP= 3 
TP= 21

## BFO-B algorithm
run main.m in the BFO-B folder 

Output:
FP=12
TP=18 



## R code for CD algorithm
run CD.R in CD folder 

Output:
FP= 59 
TP=14 

## R code for HC algorithm
run HC.R in HC folder 

Output:
FP= 11
TP=17 

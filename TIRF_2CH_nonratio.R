#     TIRF_2CH_nonratio.R
#      by Shuce Zhang July 29, 2019
#This script is to analyze two-channel (intensiometric) fluorescent change
#over time. Data are processeed to be presented in terms of delta F/F0
#Should you have any questions please contact Shuce: shuce@ualberta.ca

library(ggplot2)
library("plyr")
rm(list = ls())
############################Specify the parameters here#################
setwd("~/Research/eLACCO1.0")  # Please change the directory where your raw.txt is located.
bg <- 1   #Please specify the DMSO negative control here.
raw <- read.table("raw.txt", header = FALSE)   #input file
NN <- 1
##########################Exacting fluorescence intensity###############
ln <- nrow(raw)
cl <- ncol(raw)
region <- (cl - 5)/2 - 1
time <- raw[,2] - raw[1,2]            #time in seconds
#time <- (raw[,2] - raw[1,2])/60       #time in minites
rawF1 <- raw[,6:(6+region)]
rawF2 <- raw[,(region+7):(region*2+7)]

calc_dff <- function(rawF) {
  F <- rawF
  for (l in (1:region)) {
    F[,l] <- F[,l] - rawF[,bg]
  }
  F[,bg] <- NULL 
  itv <- vector()
  bbase <- vector()
  t <- vector()
  i <- 1
  for (j in (1:(ln-1))) {
    itv[j] <- time[j+1] - time[j]
    if ((j >1) & (itv[j] > 15)) {        # 15 sec is the minimal time for a time change
      t[i] <- time[j+1]                 #Absolute time when change occurs
      bbase[i] <- j+1                   #Time point when change occurs
      i <- i+1
    }
  }
  bbase[i] <- ln + 1                    #Record the last point
  change <- i - 1                       #number of times of solution change
  ratio <- F
  for (l in (1:ln)) {                   #r = delta F / F0
    ratio[l,] <- F[l,] / colMeans(F[(bbase[3]-10):(bbase[3]-1),])   # normalize to pH8
  }
  bl <- colMeans(ratio[(1):(bbase[1]-1),])   # the entire baseline
  apeak <- bl
  for (k in 1:change) {
    apeak <- rbind(apeak, colMeans(ratio[(bbase[k]):(bbase[k+1]-1),])-bl)     # average 
  }
  apeak <- rbind(apeak, colMeans(ratio[(bbase[k]-10):(bbase[k]-1),])-bl)    
  apeak <- rbind(apeak, colMeans(ratio[(bbase[k+1]-10):(bbase[k+1]-1),])-bl)  
  data <- cbind(time, ratio)
  matplot(time, ratio, type = 'l')
  my_list <- list("signal" = data, "apeak" = apeak)
  return(my_list)
}

i <- 1
for (FF in list(rawF1, rawF2)) {
  result = calc_dff(FF)
  write.table(result$signal, file = paste("00signal",i,".txt", sep="."), sep = ",", row.names = FALSE, col.names = FALSE)
  write.table(t(result$apeak), file = paste("00apeak",i,".txt", sep="."), sep = ",", row.names = FALSE, col.names = FALSE)
  i <- i + 1
}

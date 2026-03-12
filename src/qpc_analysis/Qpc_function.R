# QPC program

# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("qvalue")
require(qvalue)






#' Calculate Qpc
#'
#' This function calculates Qpc given data about the relatedness matrix, and a set of trait values
#' @param myZ vector of traits. Not normalized yet.
#' @param myU matrix of eigenvectors of the kinship matrix (each column is an eigenvector)
#' @param myLambdas vector of eigenvalues of the kinship matrix 
#' @param myPCcutoff a value that determines how many PCs you want to look at. For example, 0.5 would mean that you would look at the first set of PCs that explain 0.5 of the variation. The default here is 0.3
#' @param tailCutoff is there if you don't want to use the last PCs to estimate Va because of excess noise. The default value is 0.9, which means that you're not using the last 10% of your PCs. Set to 1 if you want to use all PCs
#' @param vapcs is the number of pcs used to estimate Va. Default is 50.
#' @export
#' @examples
#' calcQpc()
calcQpc <- function(myZ, myU, myLambdas, myPCcutoff = 0.3, tailCutoff = 0.9, vapcs = 50){
  myTailCutoff = round(tailCutoff*length(myLambdas)) #picks the end of the set of pcs used to calculate va
  pcm = which(sapply(1:length(myLambdas), function(x){sum(myLambdas[1:x])/sum(myLambdas)}) > myPCcutoff)[1] #the number of pcs tested
  
  myZ = myZ[1:dim(myU)[1]] - mean(myZ) #mean center phenotypes
  myCm = (myZ %*% myU)/sqrt(myLambdas) #project + standardize by the eigenvalues
  myQm = sapply(1:pcm, function(n){
    var0(myCm[n])/var0(myCm[(myTailCutoff-vapcs):myTailCutoff])
  })  #test for selection
  myPs = sapply(1:pcm, function(x){pf(myQm[x], 1, vapcs, lower.tail=F)}) #get a pvalue
  retdf = list(cm = myCm, qm = myQm, pvals = myPs)
  return(retdf)
}

#' Calculate qvalues for a table of values
#'
#' Calculates qvalues for a table of values
#' @param ptable table of values
#' @export

get_q_values <- function(ptable){
  qobj = qvalue(p = c(ptable))
  myqvals = matrix(qobj$qvalues, nrow=dim(ptable)[1])
  return(myqvals)
}

#' Calculate Va
#'
#' This function calculates additive genetic variation (Va) from a set of loci effect sizes and mean allele frequencies
#' @param afs vector of mean allele frequencies (mafs or afs are ok)
#' @param betas vector of effect sizes

#' @export

calcVa <-function(afs, betas){
  return(sum(2*afs*(1-afs)*(betas^2)))
}

#' Calculate variance where the mean is set to zero
#'
#' This function takes a string of numbers and calculates the variance of these numbers, assuming that the mean is 0.
#' @param x a string of vectors
#' @export


var0 <- function(x){  #variance where mean is set to 0
  return(sum(x^2)/length(x))
}

#' Calculate minor allele frequency
#'
#' This function takes an allele frequency (range 0 to 1) and calculates the minor allele frequency (0 to 0.5)
#' @param af an allele frequency
#' @export


getMaf = function(af){if (af <= 0.5){maf=af}
  else{ maf = 1-af}
  return(maf)
}

#' Kinship matrix function for complete data
#'
#' This function makes a kinship matrix using the cov function. 
#' @param myG matrix where the rows are individuals/populations and the columns are loci and the values are the allele frequency (not the # of copies present in an individual!!!).
#' @export


make_k_complete <- function(myG){
  scaleFactor = 1/sqrt(colMeans(myG) * (1 - colMeans(myG)))
  myS = matrix(0, nrow = dim(myG)[2], ncol = dim(myG)[2])
  diag(myS) = scaleFactor
  myM = dim(myG)[1]
  myT = matrix(data = -1/myM, nrow = myM - 1, ncol = myM)
  diag(myT) = (myM - 1)/myM
  myGstand = myT %*% myG %*% myS
  myK = cov(t(myGstand))
  return(myK)
}





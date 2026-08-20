###-------------------------------------------------
###   GWAS using GAPIT
###   PCA will be constructed with only 1M SNPS to speed up the process
###
###   Marco A Peixoto
###   02/08/2024
###
###-----------------------------------------------

## Environment and functions
rm(list=ls())
setwd("")
source("auxFunction_GAPIT.R") # This is GAPIT with the function 'GAPITPCA()' modified

###-------------------------------------------------
### 1. Read in Sweet Calls, parameter
###-----------------------------------------------
cat('Reading the cov file', '\n')

myCV <- read.delim("sweetcallsCV", header = T)
myCV<- myCV[,1:4] #only want su1 and sh2 (R and i) calls
colnames(myCV) <- c("GenID", "su1.finalCall", "sh2.finalCall", "sh2.finalCall.1")

###-------------------------------------------------
### 2. Read in Phenotype file (can be formatted as txt file and copy/paste into R as new file)
###-----------------------------------------------
cat('Reading the BLUP file', '\n')

# Make sure 1st column is "taxa" and line names match
myY <- read.delim("/Phenotypes", header = T, sep = "\t")



###-------------------------------------------------
### 3. Files
###-----------------------------------------------
cat('Reading the SNP file', '\n')

#Read in HapMAP 
myG <- read.delim("/Ia453_sweetcap_v0.4_16M2.hmp.txt", head = F)

###-------------------------------------------------
### 4. Model
###-----------------------------------------------

myGAPIT <- GAPIT(Y=myY, #1st col is ID
                 G=myG,
                 CV=myCV,
                 PCA.total=3,
                 model="FarmCPU",
                 cutOff = 0.05, #cutoff for significance, shown on Manhattan as -log10(0.05/#SNPS)
                 Geno.View.output = FALSE,
                 PCA.View.output=FALSE,
                 Multiple_analysis = FALSE)




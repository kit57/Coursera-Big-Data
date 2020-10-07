
######################################################################################################
################################## Question 1  #######################################################
######################################################################################################

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# How many properties are worth $1,000,000 or more?


# fread url requires curl package on mac 
# install.packages("curl")

library(data.table)
housing <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")

# VAL attribute says how much property is worth, .N is the number of rows
# VAL == 24 means more than $1,000,000
housing[VAL == 24, .N]

# Answer: 
# 53


######################################################################################################
################################## Question 2  #######################################################
######################################################################################################

# Use the data you loaded from Question 1. Consider the variable FES in the code book. 
# Which of the "tidy data" principles does this variable violate?


# Answer:
# Tidy data one variable per column

######################################################################################################
################################## Question 3  #######################################################
######################################################################################################


# Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat

# What is the value of:

library(xlsx)
# if (!file.exists("data")) {
#      dir.create("data")
# }
fileXLS <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
# use mode = "wb" forces binary mode - doesn't read correctly without this!
download.file(fileXLS,destfile="NGAP.xlsx", mode = "wb")
dateDownloadedXLS <- date() # if you want to store the date of download
colIndex <- 7:15 
rowIndex <- 18:23
dat <- read.xlsx("NGAP.xlsx",sheetIndex=1, colIndex = colIndex, rowIndex = rowIndex) #select first sheet, specific col/rows.
sum(dat$Zip*dat$Ext,na.rm=T) # code lesson gives your to run


# Answer:
# 36534720

######################################################################################################
################################## Question 4  #######################################################
######################################################################################################

# Read the XML data on Baltimore restaurants from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml

# How many restaurants have zipcode 21231?


#install.packages("XML")
library(XML) 
library(RCurl) 
library(dplyr)
fileXML <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

# had to remove s from https in above xml file. This method commented below:
#   fileXML <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
#   doc <- xmlTreeParse(fileXML,useInternal = TRUE)

# using RCurl, can leave https.  Use getURL first, then parse with xmlParse
xData <- getURL(fileXML) # This allows you to use https
doc <- xmlParse(xData)
rootNode <- xmlRoot(doc)
#xmlName(rootNode) # just displays top root node name
# one version, no data frame required - no need for zips, zips_dt 
sum(xpathSApply(rootNode, "//zipcode", xmlValue) == "21231")


# another version, create data frame and find answer there
zips <- xpathSApply(rootNode,"//zipcode", xmlValue) # getting the zip code data
zips_dt <- data.frame(zips, row.names = NULL) # creating a data frame from them
summary(zips_dt$zips== 21231) # find count of 21231



# another method, finds count of True instance of 21231. Uses dplyr.
count(zips_dt, zips == 21231) 


# Answer: 
# 127


######################################################################################################
################################## Question 5  #######################################################
######################################################################################################


# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

# Using the fread() command load the data into an R object
# DT

# The following are ways to calculate the average value of the variable pwgtp15
# broken down by sex. Using the data.table package, which will deliver the fastest user time?
# mean(DT|pwgtp15,by=DTSEX)
# mean(DT[DT|SEX==1,]pwgtp15);mean(DT[DTSEX==2,]pwgtp15)
# tapply(DT|pwgtp15,DTSEX,mean)
# DT[,mean(pwgtp15),by=SEX]
# sapply(split(DT|pwgtp15,DTSEX),mean)
# rowMeans(DT)[DT|SEX==1]; rowMeans(DT)[DT$SEX==2]$

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", destfile = "ACS.csv")
DT <- fread("ACS.csv", sep = ",")

# microbenchmark package allows you to run multiple versions of query "n" amount of times
# the example below runs 100 times
#install.packages("microbenchmark")
library("microbenchmark")

mbm = microbenchmark(
  v3 = sapply(split(DT$pwgtp15,DT$SEX),mean),
  v6 = DT[,mean(pwgtp15),by=SEX],
  v7 = tapply(DT$pwgtp15,DT$SEX,mean),
  v8 = mean(DT$pwgtp15,by=DT$SEX),
  #v1 = rowMeans(DT)[DT$SEX==1] rowMeans(DT)[DT$SEX==2]
  #v2 = mean(DT[DT$SEX==1,]$pwgtp15) mean(DT[DT$SEX==2,]$pwgtp15)
  times=100
)
mbm

## Answer: 
## Unit: microseconds
## expr      min        lq       mean    median        uq        max neval
##   v3  313.401  350.5510  460.18604  381.7510  448.1010   5751.801   100
##   v6 1061.300 1282.6010 6023.92894 1490.1510 1667.7010 452935.402   100
##   v7  474.001  518.4505  702.55102  567.6005  659.0010   5624.702   100
##   v8   22.301   25.0505   29.68694   26.8005   33.1015     64.400   100

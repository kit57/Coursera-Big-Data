

######################################################################################################
################################## Question 1  #######################################################
######################################################################################################

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:

#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:

#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.

# which(agricultureLogical)

# What are the first 3 values that result?


# Download file
Q1Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
Q1 <- read.csv(Q1Url)
Q1

# Computing solution
agricultureLogical <- Q1$ACR == 3 & Q1$AGS == 6
which(agricultureLogical)


# Answer:
# 125, 238,262


######################################################################################################
################################## Question 2  #######################################################
######################################################################################################


# Using the jpeg package read in the following picture of your instructor into R

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

# Loading package
library(jpeg)

# Download file
Q2Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
Q2Path = 'C:/Users/Usuario/workspace/Coursera_Big_Data/Getting and Cleaning Data/week 3/Q2.jpg'
download.file(Q2Url, Q2Path, mode = 'wb')
Q2 <- readJPEG(Q2Path, native = TRUE)
Q2

# Computing solution
quantile(Q2, probs = c(0.3, 0.8))


# Answer:
# -15259150 -10575416

######################################################################################################
################################## Question 3  #######################################################
######################################################################################################


# Load the Gross Domestic Product data for the 190 ranked countries in this data set:

#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:

#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
# Original data sources:
 
#   http://data.worldbank.org/data-catalog/GDP-ranking-table
#   http://data.worldbank.org/data-catalog/ed-stats

# Loading packages
library(dplyr)
library(data.table)


# Download file
Q3GDP_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
Q3GDP_Path <- "C:/Users/Usuario/workspace/Coursera_Big_Data/Getting and Cleaning Data/week 3/Q3GDP.csv"
Q3Edu_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
Q3Edu_Path <- "C:/Users/Usuario/workspace/Coursera_Big_Data/Getting and Cleaning Data/week 3/Q3Edu.csv"

download.file(Q3GDP_Url, Q3GDP_Path, method = "curl")
download.file(Q3Edu_Url, Q3Edu_Path, method = "curl")

# Analyze data
Q3GDP <- fread(Q3GDP_Path, skip = 5, nrows = 190, select = c(1, 2, 4, 5), col.names = c("CountryCode", "Rank", "Economy", "Total"))
Q3Edu <- fread(Q3Edu_Path)
Q3GDP

# Merging and sorting data
Q3_Merge <- merge(Q3GDP, Q3Edu, by = 'CountryCode')
Q3_Merge <- Q3_Merge %>% arrange(desc(Rank))
Q3_Merge

# Generating solution
paste(nrow(Q3_Merge), " matches, 13th country is ", Q3_Merge$Economy[13])

# Answer:
# 189 matches, 13th country is St. Kitts and Nevis

######################################################################################################
################################## Question 4  #######################################################
######################################################################################################

# What is the average GDP ranking for the “High income: OECD” and “High income: nonOECD” group?


# Computing solution
Q3_Merge %>% group_by(`Income Group`) %>%
  filter("High income: OECD" %in% `Income Group` | "High income: nonOECD" %in% `Income Group`) %>%
  summarize(Average = mean(Rank, na.rm = T)) %>%
  arrange(desc(`Income Group`))

# Answer:
# 32.96667, 91.91304


######################################################################################################
################################## Question 5  #######################################################
######################################################################################################


# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?


# Computing solution
Q3_Merge$RankGroups <- cut(Q3_Merge$Rank, breaks = 5)
vs <- table(Q3_Merge$RankGroups, Q3_Merge$`Income Group`)
vs

vs[1, "Lower middle income"]

# Answer:
# 5

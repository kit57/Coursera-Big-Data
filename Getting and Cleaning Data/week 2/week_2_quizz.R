

######################################################################################################
################################## Question 1  #######################################################
######################################################################################################

# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
# Use this data to find the time that the datasharing repo was created. What time was it created?
#   
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
# You may also need to run the code in the base R package and not R studio.


library(httr)

oauth_endpoints("github")

myapp <- oauth_app("github",
                   key = "75ffc4989df8001de43a",
                   secret = "389877827ca7031f4586a37206816ec5152088dc")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)

datashare <- which(sapply(output, FUN=function(X) "datasharing" %in% X))
datashare


list(output[[15]]$name, output[[15]]$created_at)

# Answer:
# "2013-11-07T13:25:07Z"


######################################################################################################
################################## Question 2  #######################################################
######################################################################################################


# The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.

# Download the American Community Survey data and load it into an R object called 

# acs

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?

library(sqldf)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "acs.csv")

acs <- read.csv("acs.csv")
head(acs)


# Option A
detach("package:RMySQL", unload=TRUE)
sqldf("select pwgtp1 from acs where AGEP < 50")

# Option B
sqldf("select * from acs where AGEP < 50 and pwgtp1")

# Option C
sqldf("select pwgtp1 from acs")

# Option D
sqldf("select pwgtp1 from acs where AGEP < 50")


# Answer:
# sqldf(“select pwgtp1 from acs where AGEP < 50”)

######################################################################################################
################################## Question 3  #######################################################
######################################################################################################

# Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)


Z <- unique(acs$AGEP)

# Option A
A <- sqldf("select AGEP where unique from acs")

# Option B
B <- sqldf("select distinct AGEP from acs")
identical(Z, B$AGEP)

# Option C
C <- sqldf("select distinct pwgtp1 from acs")
identical(Z, C$AGEP)

# Option D
D <- sqldf("select unique AGEP from acs")

# Answer:
# sqldf(“select distinct AGEP from acs”)

######################################################################################################
################################## Question 4  #######################################################
######################################################################################################

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#   http://biostat.jhsph.edu/~jleek/contact.html

# (Hint: the nchar() function in R may be helpful)

htmlUrl <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlUrl)
close(htmlUrl)

head(htmlCode)

c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))

# Answer:
# 45 31  7 25


######################################################################################################
################################## Question 5  #######################################################
######################################################################################################


# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
#   https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for

# (Hint: this is a fixed width file format)

data <- read.fwf(file = "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",
                 skip = 4,
                 widths = c(12, 7,4, 9,4, 9,4, 9,4))
sum(data[, 4])


# Answer:
# 32426.7





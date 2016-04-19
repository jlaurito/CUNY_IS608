#
# getting and cleaning data (this code is only run once)
# set working directory to where this file is
setwd('/Users/josh.laurito/src/CUNY_IS608/lecture3/shiny_graph_sample')


# pull in data
mort <- read.csv('../data/cdc-mortality-1999-2010.csv',
                 header=TRUE,
                 sep = ',')


# check data
summary(mort)


# problems:
#  - some NA's
#  - Crude.Rate is being treated like a string -  let's see why

head(sort(mort$Crude.Rate), 100)

# so let's clean

mort_clean <- mort[complete.cases(mort),]
rem_txt <- function(x) { as.numeric(gsub("[[:alpha:] ()]", '', x)) } 
mort_clean$Crude.Rate <- sapply(mort_clean$Crude.Rate, rem_txt)

write.csv(mort_clean, 
          file='../data/cleaned-cdc-mortality-1999-2010.csv',
          row.names=FALSE)



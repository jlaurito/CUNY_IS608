# IS608 Final Project
# Brian Chu, May 15, 2014
# FSA cost and sentence reduction data transformation and export


library(XLConnect)
library(plyr)
library(reshape2)

# load files
cost <- readWorksheetFromFile("USSCFY13.xlsx", sheet="Cost")
dec <- readWorksheetFromFile("USSCFY13.xlsx", sheet="Reduction")
abbr <- readWorksheetFromFile("USSCFY13.xlsx", sheet="Abbr")

# join cost and sentence reduction data, exclude outlying territories
costdec <- merge(dec, cost, by='State', all.x=TRUE)
exclude <- c("Northern Mariana Islands", "Puerto Rico", "Virgin Islands", "Guam")
costdec <- subset(costdec, !(costdec$State %in% exclude))
costdec$avgPercReduce <- costdec$AvgPercDec/100

#join state abbreviations
costdec <- merge(costdec, abbr, by='State')

# summarize variables into new dataframe
cost_state <- ddply(costdec, .(state=State, state_abbr=State_abbr), summarise, avgCurr=mean(AvgCurr), avgNew=mean(AvgNew), avgMonthReduce=mean(AvgDec), avgPercReduce=round(mean(AvgPercDec/100),2), avgDailyInmate=mean(AvgDailyInmate), taxCost=mean(TaxCost), avgAnnCost=mean(AvgAnnCost), NgrantReduce=sum(N), NdenyAll=mean(Denied), percGrant=mean(NgrantReduce/(NgrantReduce+Denied)), percDeny=mean(Denied/(NgrantReduce+Denied)))

# for states with no cost data, replace NA with median cost of other states 
medianAnnCost <- median(cost_state$avgAnnCost, na.rm=TRUE)
cost_state$avgAnnCost <- ifelse(is.na(cost_state$avgAnnCost), medianAnnCost, cost_state$avgAnnCost)

# calculate savings per inmate and original granted
cost_state$savePerInmate <- round(cost_state$avgAnnCost * (cost_state$avgMonthReduce/12),0)
cost_state$saveTotalOrig <- round((cost_state$savePerInmate * cost_state$NgrantReduce), -2)

# subset key fields into new dataframe
cs <- cost_state[c('state', 'state_abbr', 'avgCurr', 'avgNew', 'avgMonthReduce', 'avgPercReduce', 'avgAnnCost', 'savePerInmate', 'saveTotalOrig', 'NgrantReduce', 'NdenyAll', 'percGrant', 'percDeny')]

# export as csv
write.csv("FSAcrackcost.csv", x=cs)

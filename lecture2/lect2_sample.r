# sample code to create graphs using bigvis

library("bigvis")
library("ggplot2")

pData <- read.csv("data/all_PLUTO_data.csv")

# does lot area change with year of construction?
lotArea  <-pdata$LotArea[pdata$YearBuilt > 1850 & pdata$LotArea > 100 & pdata$AssessTot < 10000000 & pdata$NumFloors != 0 ]
yrBuilt  <- pdata$YearBuilt[pdata$YearBuilt > 1850 & pdata$LotArea > 100 & pdata$AssessTot < 10000000 & pdata$NumFloors != 0  ]

# let's plot 5 year averages)
yr <- condense(bin(yrBuilt, 5), z=lotArea)
autoplot(yr) + xlim(1900, 2014) + ylim(0, 10000) + ylab('Lot Area')

# now let's get a sense of the distribution (log gradient)
areaVsYr <- condense(bin(yrBuilt, 2), bin(lotArea, 1000))
# tail(areaVsYr)

myBreaks <- c(100000, 10000, 1000, 100, 10, 1)

p <- autoplot(areaVsYr) + theme(panel.background=element_rect(fill='white'))  + ylim(0, 200000)
p + scale_fill_gradient(limits= c(1,100000), 
                        low='grey', 
                        high='blue',
                        trans="log",
                        breaks=myBreaks)
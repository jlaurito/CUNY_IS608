# sample code to create graphs using bigvis
# installation
# library('devtools')
# install_github(repo='hadley/bigvis')

library("bigvis")
library("ggplot2")

pData <- read.csv("data/some_PLUTO_data.csv")

# does lot area change with year of construction?
lotArea  <-pData$LotArea[pData$YearBuilt > 1850 & pData$LotArea > 100 & pData$AssessTot < 10000000 & pData$NumFloors != 0 ]
yrBuilt  <- pData$YearBuilt[pData$YearBuilt > 1850 & pData$LotArea > 100 & pData$AssessTot < 10000000 & pData$NumFloors != 0  ]

# let's plot 5 year averages)
yr <- condense(bin(yrBuilt, 5), z=lotArea)
autoplot(yr) + xlim(1900, 2014) + ylim(0, 10000) + ylab('Lot Area')

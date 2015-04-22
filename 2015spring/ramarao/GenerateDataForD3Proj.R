# Tulasi Ramarao
# to clean and use data in a csv file for D3
library(sqldf)
library(plyr) # for arrange
library(reshape) # to shape data

# Setting working Directory
setwd("/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject")

# loading data
mydata <- read.csv("/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject/gtd_06to13_0814distcsvmac.csv", header = TRUE, 
                   sep = ",", check.names = FALSE)
#summary(mydata)

# select columns needed
mydata1 <- subset(mydata,select=c("iyear", "weaptype1","weaptype1_txt","nkill"),quote=FALSE)

colnames(mydata1) <- c("year","weaponType","weaponDesc","totalkilled")

head(mydata1)

#sort data
mydata1 <- mydata1[order(mydata1$year),]

head(mydata1)

mydata1 <- as.data.frame(sapply(mydata1, function(x) gsub("\"", "", x)))

mydata1[, 1:4] <- apply(mydata1[, 1:4], 2, function(x) { 
  gsub("\\'", "", x)
})


#mydata1

# NAs introduced by coercsion
mydata1 <- mydata1[apply(mydata1,1,function(x)any(!is.na(x))),]
head(mydata1)

# so remove nas
mydata1 <- na.omit(mydata1)
mydata1 <- mydata1[complete.cases(mydata1),]
#str(mydata1)

mydata1 <- transform(mydata1,year = as.numeric(year),
                     weaponType = as.numeric(weaponType),
                     totalkilled = as.numeric(as.character(totalkilled) ) )
#str(mydata1)

# get unique rows
mydata1 <- unique(mydata1[1:4])
mydata1$value=rnorm(nrow(mydata1[1:4]))

mydata1 <- unique(mydata1)
mydata1$value=rnorm(nrow(mydata1))

head(mydata1)
# select desired data
#mydata1sel <- sqldf("SELECT distinct year, weaponType, weaponDesc, totalkilled FROM mydata1 where totalkilled > 0 ")
# mydata1sel <- sqldf("SELECT distinct mydata1a.year, mydata1a.totalkilled, mydata1b.totalkilled
#                       FROM mydata1 mydata1a,mydata1 mydata1b
#                     where mydata1a.weaponType = 6 OR mydata1a.weaponType = 5")

mydata1sela <- sqldf("SELECT year, totalkilled FROM mydata1
                     where weaponType = 6 order by year")

head(mydata1sela,10)

# sum up
mydata1sela <- aggregate(cbind(totalkilled) ~  year, data=mydata1sela, FUN = sum)
head(mydata1sela)

mydata1sela$totalkilled <- round(mydata1sela$totalkilled)
head(mydata1sela)

mydata1selb <- sqldf("SELECT year, totalkilled FROM mydata1
                    where weaponType = 5 order by year")

head(mydata1selb,10)

# sum up
mydata1selb <- aggregate(cbind(totalkilled) ~  year, data=mydata1selb, FUN = sum)
head(mydata1selb)
mydata1selb$totalkilled <- round(mydata1selb$totalkilled)
head(mydata1selb)

# combine two data frames
mydata1sel <- merge(mydata1sela,mydata1selb,by = "year")
head(mydata1sel)

# sort by year
mydata1sel <- mydata1sel[order(mydata1sel$year),]
head(mydata1sel)

# rename columns
colnames(mydata1sel) <- c("year","Explosives","Firearms")

# Write to a CSV file 
write.table(mydata1sel, file = "/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject/myd3data2.csv",row.names=FALSE, na="",sep=",")

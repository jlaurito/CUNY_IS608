# Tulasi Ramarao
## DATA MUNGING FOR Weapons data
# to clean and use data in a csv file for D3
library(sqldf)
library(plyr) # for arrange
library(reshape) # to shape data

# Setting working Directory
setwd("/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject")

# loading data
mydata <- read.csv("/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject/gtd_06to13_0814distcsvmac.csv", header = TRUE, 
                  sep = ",", check.names = FALSE)
colnames(mydata)

mydata1 <- subset(mydata,select=c("nkill","weaptype1","weaptype1_txt","iyear"),quote=FALSE)

colnames(mydata1) <- c("totalkilled","weapontype","weaponDesc","year")

head(mydata1)

#sort data
mydata1 <- mydata1[order(mydata1$weapontype),]

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

head(mydata1)
mydata1 <- transform(mydata1,totalkilled = as.numeric(as.character(totalkilled) ),
                     weapontype = as.numeric(as.character(weapontype)),
                     year = as.numeric(as.character(year))
                     )
#str(mydata1)


mydata1 <- unique(mydata1[1:4])
mydata1$value=rnorm(nrow(mydata1[1:4]))

mydata1 <- unique(mydata1)
mydata1$value=rnorm(nrow(mydata1))

head(mydata1)
# select desired data
#mydata1sel <- sqldf("SELECT distinct year, weaponType, weaponDesc, totalkilled FROM mydata1 where totalkilled > 0 ")
mydata1sel <- sqldf("SELECT distinct weapontype,weaponDesc, totalkilled, year
                      FROM mydata1 
                    where totalkilled > 0 ")
head(mydata1sel)

#summary(mydata1sel)
colnames(mydata1sel) <- c("weapontype","weapondesc","totalkilled","year")

mydata1sel <- sqldf("SELECT distinct weapontype,weapondesc, totalkilled,year
                      FROM mydata1sel where year = 2013
                      Group by weapontype")
head(mydata1sel)

mydata1sel <- mydata1sel[order(mydata1sel$weapontype),]
head(mydata1sel)

#to sum up
mydata1sel <- aggregate(cbind(totalkilled) ~ weapontype + weapondesc + year, data=mydata1sel, FUN = sum)
head(mydata1sel)

# Write to a CSV file 
write.table(mydata1sel, file = "/Users/tulasiramarao/SpringSem2015/FinalProject/MyProject/fatalitiesbyweapons.csv",row.names=FALSE, na="",sep=",")



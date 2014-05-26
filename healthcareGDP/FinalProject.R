install.packages("plyr")
install.packages("googleVis")
install.packages("maps")
install.packages("mapdata")
library('maps')
library('mapproj') 
library('rgeos')
library('maptools')
library('rworldmap')
library('RColorBrewer')
library('mapdata')
library('googleVis')
library('ggplot2')
library('reshape2')
library('sqldf')
options(repos = c(CRAN = "http://cran.rstudio.com"))
# Final Project IS608 Knowledge and Visual Analytics
#===============================================================================================================
#Loading Data and setting working Directory
setwd("C:\\Users\\dundeva\\Desktop\\SPS\\IS608\\CUNY_IS608-master\\FinalProject")

# loading Health Care expenditure data
hcare <- read.csv('../FinalProject/HealthcareExpenditurecleaned.csv',header=TRUE,sep = ',',check.names=FALSE)
summary(hcare)


# loading life expectancy data
lifexpct1 <- read.csv('../FinalProject/LifeExpectancycleaned.csv',header=TRUE,sep = ',',check.names=FALSE)
summary(lifexpct1)


# loading Regions 
cregion <- read.csv('../FinalProject/Region.csv',header=TRUE,sep = ',',check.names=FALSE)
summary(cregion)

#loading Shape File
np_dist2<- readShapeSpatial("../FinalProject/ne_110m_admin_0_countries.shp")

#===============================================================================================================
#===============================================================================================================
## Transforming data from Wide to long for Cost
hc<-reshape(hcare,varying=c("1995","1996","1997","1998","1999","2000"
                            ,"2001","2002","2003","2004","2005","2006"
                            ,"2007","2008","2009","2010","2011","2012"),
            v.names="cost",
            timevar="Year",
            times=c("1995","1996","1997","1998","1999","2000"
                    ,"2001","2002","2003","2004","2005","2006"
                    ,"2007","2008","2009","2010","2011","2012"),
            direction="long"
            )
#===============================================================================================================
## Transforming data from Wide to long for length of life

life<-reshape(lifexpct1,varying=c("1995","1996","1997","1998","1999",
                            "2000","2001","2002","2003","2004","2005"
                            ,"2006","2007","2008","2009","2010","2011","2012"),
            v.names="Age",
            timevar="Year",
            times=c("1995","1996","1997","1998","1999","2000"
                    ,"2001","2002","2003","2004","2005","2006"
                    ,"2007","2008","2009","2010","2011","2012"),
            direction="long"
)
#===============================================================================================================
#merging lie expectancy and cost data sets

hl <- sqldf("SELECT hc.Countryname,hc.CountryCode, hc.Year , hc.cost, life.Age 
       FROM hc LEFT JOIN life where hc.CountryName= life.CountryName 
             and hc.CountryCode=life.countryCode 
             and hc.Year=life.Year ")

#Adding Regions to data set
hl2<-sqldf("Select hl.Countryname,hl.CountryCode, hl.Year , hl.cost, hl.Age,cregion.Region
           from hl left join cregion where hl.CountryCode=cregion.CountryCode
           and hl.Countryname=cregion.CountryName
           and cregion.Region !=''")

head(hl2)
summary(hl2)
str(hl2)
#===============================================================================================================
#===============================================================================================================

#plotting static heat maps for Cost and Life Expectancy
sPDF <- joinCountryData2Map(hl2,joinCode="NAME" , nameJoinColumn ="CountryName")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData( sPDF,mapTitle='World Health Cost', nameColumnToPlot="cost")

sPDF <- joinCountryData2Map(hl2,joinCode="NAME" , nameJoinColumn ="CountryName")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData( sPDF,mapTitle='World Life Expectancy ', nameColumnToPlot="Age")

#===============================================================================================================
#Creating Geo Charts with googlevis package
GeoChart <- gvisGeoChart(hl2, "CountryName", "cost","Age",
options=list(width=610, height=400,
colorAxis="{colors:['#99FF66','#2EB82E','#006600']}",
                   backgroundColor="#F0F0F0"))
# Display chart
plot(GeoChart)
#===============================================================================================================
D <- transform(hl2, Year = as.numeric(Year))

# plotting a subset of the data to compare spending against Age
(hsb7 <- D[D$CountryCode %in% c('BRA','CHN', 'IND', 'RUS', 'USA','GBR','CAN','AUS'), ])
G <- gvisGeoChart(hsb7, "CountryName", "cost","Age", options=list(width=610, height=400,
                                    colorAxis="{colors:['#99FF66','#2EB82E','#006600']}",
                                    backgroundColor="#F0F0F0"),chartid="c1")
T <- gvisTable(hsb7, options=list(width=610, height=270), chartid="c2")
GT <- gvisMerge(G,T, horizontal=FALSE,chartid="gt") 
M <- gvisMotionChart(hsb7, "CountryCode", "Year",
                     options=list(width=610, height=670),chartid="c3")

GTM <- gvisMerge(GT, M, horizontal=TRUE,
                 tableOptions="bgcolor=\"#CCCCCC\" cellspacing=10",chartid="gtm")

# Display chart

plot(GTM)
#===============================================================================================================
## Bar and Line chart
Combo <- gvisComboChart(hsb7, xvar="CountryName",
                        yvar=c("cost","Age"),
                        options=list(seriesType="bars",
                                     series='{1: {type:"line"}}'))
plot(Combo)
#==============================================================================================================



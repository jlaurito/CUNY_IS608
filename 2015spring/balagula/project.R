install.packages("dplyr")
install.packages("googleVis")
library(rgeos)
library(maptools)
library(plyr)
library(dplyr)
library(ggplot2)
library(gpclib)
library(googleVis)


# Step 1. Prepare Data

# Step 1.1 Load staff data.
# First data frame contains all numeric fields as numbers but ENTITY_CD is also converted into number
# which removed all leading zeros - not good  
staff <- read.csv("staff.csv", , stringsAsFactors = FALSE)
# Load the same data but this time all fields as characters
staff1 <- read.csv("staff.csv", , stringsAsFactors = FALSE,colClasses="character")
# Add ENTITY_CD IN character format into the original dataframe
staff$ENTITY_CD_CHAR <- cbind(staff1$ENTITY_CD)
# Extract first 2 characters of ENTITY_CD - this is our COUNTY_ID
staff$COUNTY_ID <- substr(staff$ENTITY_CD_CHAR,1,2)

s <-aggregate(staff, by=list(staff$COUNTY_ID), FUN=mean, na.rm=TRUE)


# We are interested in the following fields:
# PER_NO_VALID_CERT Percent of teachers with no valid teaching certificate
# PER_TEACH_OUT_CERT Percent of individuals teaching out of certification
# PER_FEWER_3YRS_EXP Percent of teachers with fewer than three years of teaching experience
# PER_MAS_PLUS Percent of teachers with Master’s Degree plus 30 hours or doctorate
# PER_NOT_HQ Percent of core classes not taught by highly qualified teachers
# PER_NO_APPROP_CERT Percent of classes taught by teachers without appropriate certification
# PER_TURN_FIVE_YRS Turnover rate of teachers with fewer than five years of experience
# PER_TURN_ALL Turnover rate of all teachers

staff_agg <- s[,c("Group.1","PER_NO_VALID_CERT","PER_TEACH_OUT_CERT", "PER_FEWER_3YRS_EXP","PER_MAS_PLUS", "PER_NOT_HQ", "PER_NO_APPROP_CERT", "PER_TURN_FIVE_YRS", "PER_TURN_ALL")]
names(staff_agg)[1]<-"COUNTY_ID"
staff_agg$COUNTY_ID_NUM <- as.numeric(staff_agg$COUNTY_ID)

# Now we have all of the aggregate staff data available in one dataframe

# Let's prepare county data 
c_map <- readShapeSpatial("cty036.shp")
c_map <- fortify(c_map, region = "COUNTY")
c_map$id <- as.numeric(c_map$id)

# Need to associate FIPS codes with county codes used by NYS Dept of Education
# Reference: http://www.nysed.gov/admin/County.txt
c_data <- read.csv("c_data.csv", , stringsAsFactors = FALSE)
names(c_data)[3]<-"COUNTY_ID_NUM"
staff_county <- right_join(staff_agg, c_data)

county_centers <- ddply(c_map, .(id), summarize, clat = mean(lat), clong = mean(long))
plotData <- right_join(county_centers, staff_county)





# Step 1.2 Load ELA performance data for 2014.
# First data frame contains all numeric fields as numbers but ENTITY_CD is also converted into number
# which removed all leading zeros - not good  
ela <- read.csv("ela.csv", , stringsAsFactors = FALSE)

# Load the same data but this time all fields as characters
ela1 <- read.csv("ela.csv", , stringsAsFactors = FALSE,colClasses="character")

# Add ENTITY_CD IN character format into the original dataframe
ela$ENTITY_CD_CHAR <- cbind(ela1$ENTITY_CD)

# Extract first 2 characters of ENTITY_CD - this is our COUNTY_ID
ela$COUNTY_ID <- substr(ela$ENTITY_CD_CHAR,1,2)

# Proficiency is defined as level 3 or 4 on tests
ela$PCT_PROFICIENT_ELA <- as.numeric(ela$LEVEL3_.TESTED) + as.numeric(ela$LEVEL4_.TESTED)

# Limit results to year 2014
ela <- ela[ela$YEAR==2014,]

# Find mean percentage of proficient students by county
ela_agg <-aggregate(ela, by=list(ela$COUNTY_ID), FUN=mean, na.rm=TRUE)
ela_agg <- ela_agg[,c("Group.1", "PCT_PROFICIENT_ELA")]
names(ela_agg)[1]<-"COUNTY_ID"
ela_agg$COUNTY_ID_NUM <- as.numeric(ela_agg$COUNTY_ID)
ela_agg <- ela_agg[ela_agg$COUNTY_ID_NUM != 0,]

# join to the original data frame
plotData <- left_join(plotData, ela_agg)


# Step 1.3 Load Math performance data for 2014
math_data <- read.csv("math.csv", , stringsAsFactors = FALSE)

# Load the same data but this time all fields as characters
math_data1 <- read.csv("math.csv", , stringsAsFactors = FALSE,colClasses="character")

# Add ENTITY_CD IN character format into the original dataframe
math_data$ENTITY_CD_CHAR <- cbind(math_data1$ENTITY_CD)

# Extract first 2 characters of ENTITY_CD - this is our COUNTY_ID
math_data$COUNTY_ID <- substr(math_data$ENTITY_CD_CHAR,1,2)

# Proficiency is defined as level 3 or 4 on tests
math_data$PCT_PROFICIENT_MATH <- as.numeric(math_data$LEVEL3_.TESTED) + as.numeric(math_data$LEVEL4_.TESTED)

# Limit results to year 2014
math_data <- math_data[math_data$YEAR==2014,]

# Find mean percentage of proficient students by county
math_data_agg <-aggregate(math_data, by=list(math_data$COUNTY_ID), FUN=mean, na.rm=TRUE)
math_data_agg <- math_data_agg[,c("Group.1", "PCT_PROFICIENT_MATH")]
names(math_data_agg)[1]<-"COUNTY_ID"
math_data_agg$COUNTY_ID_NUM <- as.numeric(math_data_agg$COUNTY_ID)
math_data_agg <- math_data_agg[math_data_agg$COUNTY_ID_NUM != 0,]
plotData <- left_join(plotData, math_data_agg)

# The final data frame contains:
# - Staff statistics by county
# - ELA performance data by county
# - Math performance data county

# Step 2. Plotting data

# This is a test choropleth map with ggplot
ggplot(plotData, aes(map_id = id)) +
    geom_map(aes(fill =PER_TURN_ALL), map = c_map, color ="black" ) +
    expand_limits(x = c_map$long, y = c_map$lat) +
     theme(legend.position = "bottom",
         axis.ticks = element_blank(), 
         axis.title = element_blank(), 
         axis.text =  element_blank()) +
    #scale_fill_gradient(low="white", high="blue") +
    guides(fill = guide_colorbar(barwidth = 10, barheight = .5)) + 
    #geom_text(data = plotData, aes(x = clong, y = clat, label = c_name)) +
    ggtitle("Teacher's Turnover by County")


plot(plotData$PER_TURN_ALL , plotData$PCT_PROFICIENT_ELA, main="Teachers Turnover vs Students ELA Performance", 
  	xlab="Turnover rate of all teachers ", ylab="ELA Proficiency (% of all students) ", pch=19)

plot(plotData$PER_TURN_ALL , plotData$PCT_PROFICIENT_MATH, main="Teachers Turnover vs Students Math Performance", 
  	xlab="Turnover rate of all teachers ", ylab="Math Proficiency (% of all students) ", pch=19)

# getting statistics
m<-lm(plotData$PER_TURN_ALL ~ plotData$PCT_PROFICIENT_ELA)
summary(m)

m<-lm(plotData$PER_TURN_ALL ~ plotData$PCT_PROFICIENT_MATH)
summary(m)
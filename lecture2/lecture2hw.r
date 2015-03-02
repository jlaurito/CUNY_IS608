# IS608 HW 2
# Paul Garaud

require(ggplot2)
require(scales)
require(bigvis)

# Read in data, assign subsets, and remove large data from memory
data <- read.csv(choose.files(), header = TRUE)
post1850 <- data[data$YearBuilt >= 1850,]
rm(data)

# value outliers in 1933
max.val.by.yr <- post1850 %>% group_by(YearBuilt) %>% 
  summarize(maxVal=max(AssessTot))
ggplot(max.val.by.yr, aes(x=YearBuilt, y=maxVal)) + geom_line()
rm(max.val.by.yr)

# remove outliers
post1850 <- post1850[post1850$AssessTot < 2e9, ]

# define data to be used below
built <- post1850$YearBuilt
floors <- with(post1850, condense(bin(YearBuilt, 5), bin(NumFloors, 5)))
ww2 <- subset(post1850,YearBuilt >= 1930 & YearBuilt <= 1955 & NumFloors != 0 &
                AssessTot > 0)

# assessed value per floor
val.by.flr <- with(ww2[, 2:4], condense(bin(YearBuilt, 1), 
                                        bin(log(AssessTot / NumFloors), 1)))
mean.val <- with(ww2, condense(bin(YearBuilt, 1), z=log(AssessTot / NumFloors)))

# assessed value per floor * lot size
ww2 <- subset(ww2, LotArea > 0)
val.by.flot <- with(
  ww2, 
  condense(bin(YearBuilt, 1), 
           bin(log(AssessTot / (NumFloors * LotArea)), 0.75)
  )
)
mean.flot <- with(ww2, condense(bin(YearBuilt, 1), 
                                z=log(AssessTot / (NumFloors * LotArea))))

rm(post1850)
rm(ww2)

#### Graph of when buildings were constructed ####

built_c <- condense(bin(built, 5))
built_s <- smooth(built_c, 20)
autoplot(built_s) + scale_x_continuous(breaks=seq(1850, 2020, 10)) +
  labs(title='NYC Buildings by Year Built', x='Year', y='Number of buildings')

# The data 1920-40 seems a bit suspect, with double or triple the level of
# construction as compared to before and after.

# This is also visible from a cumulative distribution plot
# Note how the slope changes from trend over the above period
ggplot(built_c, aes(x=built, y=cumsum(.count / sum(.count)))) + 
  geom_area(alpha=.5) +
  labs(title='Cumulative plot of building built date', x='Year',
       y='Buildings built before year') +
  scale_x_continuous(breaks=(seq(1850, 2020, 10))) +
  scale_y_continuous(labels=percent_format())  # <-- requires scales library
    
# Also, it seems unlikely that there was no construction whatsoever 1850-90


#### Graph of buildings of a certain # of floors built by year ####
floors['.count'] <- log(floors['.count'])  # convert count to log scale
ggplot(floors, aes(x=YearBuilt, y=NumFloors, fill=.count)) + 
  geom_raster() +
  labs(title='Buildings by floors built over time',
       x='Year', y='Number of buildings') +
  theme_classic() + scale_fill_gradient(low='darkslategray', high='white') +
  scale_x_continuous(breaks=(seq(1850, 2020, 10)))

#### Graph assessed value by floor for around WW2 ####
names(val.by.flr)[2] <- 'Val'
ggplot(val.by.flr, aes(x=YearBuilt, y=Val, fill=.count)) + geom_raster() + 
  scale_fill_continuous(trans='log') + 
  labs(title='Mean and distribution of log assessed value per floor (1930-1955)',
       x='Year built', y='Log of assessed value per floor',
       fill='Assessed value per floor') +
  geom_line(data=mean.val, aes(x=YearBuilt, y=.mean), color='red') +
  geom_point(data=mean.val, aes(x=YearBuilt, y=.mean), color='red')

# Appears that hypothesis is plausible--there is a slight dip in mean value
# per floor. What about when we divide by lot size as well?
names(val.by.flot)[2] <- 'Val'
ggplot(val.by.flot, aes(x=YearBuilt, y=Val, fill=.count)) + geom_raster() + 
  scale_fill_continuous(trans='log') + 
  labs(title='Mean and distribution of log assessed value per floor (1930-1955)',
       x='Year built', y='Log of assessed value per floor',
       fill='Assessed value per floor') +
  geom_line(data=mean.flot, aes(x=YearBuilt, y=.mean), color='red') +
  geom_point(data=mean.flot, aes(x=YearBuilt, y=.mean), color='red')
  
# Even adjusting for lot size, the hypothesis seems to hold
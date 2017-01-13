## 
## Module 1 Homework: an example of visualization in the 
## feedback loop
##


# load libraries

library(ggplot2)
library(plyr)


# set working directory

setwd("/Users/JL/Box Sync/CUNY/CUNY_IS608")


# load data

inc <- read.csv("lecture1/data/inc5000_data.csv", header= TRUE)

# conduct a quick data quality investigation
head(inc)
summary(inc)
summary(inc[,c(3:6,8)])

# see we have NA's, will exclude

all_inc <- inc[complete.cases(inc)==TRUE,]


# aggregate by state 
cnt <- ddply(all_inc, .(State), summarize, cnt = length(State))
p <- ggplot(cnt, aes(x=State, y=cnt)) + geom_bar(stat='identity') 
p

# flip coords
p <- ggplot(cnt, aes(x=State, y=cnt)) + geom_bar(stat='identity')  
p + coord_flip()

# look at the state with the 3rd most companies on the list. 
# Let's look at their companies by Industry
# head(ny)
ny <- subset(all_inc, State == 'NY')
p <- ggplot(ny, aes(x=Industry, y=Employees)) + geom_point() 
p + coord_flip()


# uh oh, we have an outlier that makes this analysis difficult

# compute lower and upper whiskers
winsor <- function(x, bot, top)  { return(min(top, max(x, bot))) }
ny$clip_employ <- sapply(ny$Employees, winsor, bot=0, top =2500)
p3 <- ggplot(ny, aes(x=Industry, y=clip_employ)) 

p3 + geom_point() + coord_flip()

# boxplot
p3 + geom_boxplot() + coord_flip(ylim=c(0,2500))

# handle outliers
p3 + geom_boxplot() + coord_flip(ylim=c(0,2500)) +
  annotate('text', label= c('outliers','3,000','10,000','32,000'),
           x = c(18,16,5,2), y=c(2300,2400,2400,2400), size=c(4,3,3,3))  

# look at ranges and averages
ny_ave <- ddply(ny, .(Industry), summarize,
                mean <- mean(Employees),
                sd <- sd(Employees),
                median <- median(clip_employ),
                lower <- quantile(clip_employ)[2],
                upper <- quantile(clip_employ)[4]  
              )

names(ny_ave) <- c('Industry', 'mean', 'sd', 'median', 'lower', 'upper')

head(ny_ave,2)

# show point ranges
p4 <- ggplot(ny_ave, aes(x=Industry, y=median)) + geom_point()
p4 <- p4 + geom_pointrange(ymin=ny_ave$lower, ymax=ny_ave$upper) 
p4 + ylim(c(0,750)) + coord_flip()

p5 <- ggplot(ny_ave, aes(x=Industry, y=median)) + geom_bar(stat='identity')
p5 <- p5 + geom_errorbar(ymin=ny_ave$lower, ymax=ny_ave$upper, width=.1, color='red') 
p5 + ylim(c(0,750)) + coord_flip()

# investor info
all_inc$rev_per_employ <- all_inc$Revenue / all_inc$Employees
p6 <- ggplot(all_inc, aes(x=Industry, y=rev_per_employ))
p6 + geom_boxplot() + coord_flip()





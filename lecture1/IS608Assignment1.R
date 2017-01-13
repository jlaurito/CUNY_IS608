# IS608 Assignment 1
# Paul Garaud

require(dplyr)
require(ggplot2)
require(gridExtra)
require(stringr)

# import data
data.loc <- choose.files(paste(getwd(), '/lecture1/data/inc5000_data.csv', sep=''))
df <- tbl_df(read.csv(data.loc, header=TRUE))

# check data
str(df)

#### 1. Distribution of companies by state ####
# sorted alphabetically
comp.by.state <- df %>% count(State) %>% transform(State=reorder(State, desc(State)))

# sorted by count (desc)
comp.by.state.o <- comp.by.state %>% transform(State=reorder(State, n)) %>% arrange(State)

plot1 <- ggplot() + geom_bar(stat='identity', data=comp.by.state, aes(State, n)) +
  coord_flip() + labs(title='Sorted Alphabetically', y='Number of Companies')
plot2 <- ggplot() + geom_bar(stat='identity', data=comp.by.state.o, aes(State, n)) +
  coord_flip() + labs(title='Sorted By Count', y='Number of Companies')

# plot both sort orders together
grid.arrange(plot1, plot2, ncol=2)

#### 2. 3rd most state: avg employment by industry ####
# Complete cases for NY (ie, state with 3rd most companies)
df.comp <- tbl_df(df[df$State == 'NY' & complete.cases(df),])

# identify outliers

# visual inspection to identify outliers
ggplot(data=df.comp, aes(Industry, Employees)) + geom_boxplot() +
  coord_flip()

# exclude outliers
no.outliers <- df.comp %>% group_by(Industry) %>% 
  mutate(q25=quantile(Employees)[2], q75=quantile(Employees)[4],
         iqr=q75-q25, lbound=q25-1.5*iqr, hbound=q75+1.5*iqr) %>% 
  subset(Employees > lbound & Employees < hbound)

emp.by.ind <- no.outliers %>% group_by(Industry) %>% 
  summarize('Mean.Employees'=mean(Employees), Count=n(), 
            Std.Dev=sd(Employees)) %>% 
  transform(Industry=reorder(Industry, desc(Industry)))

# repeat plot without outlier
ggplot(data=emp.by.ind, aes(Industry, Mean.Employees)) + geom_bar(stat='identity') +
  geom_pointrange(aes(ymin=Mean.Employees - Std.Dev,
                    ymax=Mean.Employees + Std.Dev, color='red'), position='dodge') + 
  coord_flip() + scale_colour_discrete(name='', breaks=c('red'), labels=c('Std Dev')) +
  ylab('Mean number of employees')

# sense check: Biz products & Services
# df1 <- df.comp[df.comp$Industry == 'Business Products & Services', ]
# df2 <- no.outliers[no.outliers$Industry == 'Business Products & Services', ]
# ggplot() + geom_histogram(data=df2, aes(Employees)) + facet_grid(Industry ~ .)
# ggplot() + geom_histogram(data=df1, aes(Employees)) + facet_grid(Industry ~ .)


#### 3. Industries that generate the most revenue per employee ####
df.rev.by.emp <- df[complete.cases(df), ] %>% 
  mutate(rev.emp=Revenue / Employees) %>%
  group_by(Industry) %>%
  summarize(Revenue=sum(Revenue) / sum(Employees), Num=n(),
            Min=min(rev.emp), Max=max(rev.emp), 
            Dispersion=(Max - Min) / Revenue) %>%
  transform(Industry=reorder(Industry, Revenue))

ggplot(df.rev.by.emp, aes(Industry, Revenue, fill=Dispersion)) + 
  geom_bar(stat='identity', width=.8) + ylab('Revenue Per Employee (RPE)') +
  scale_fill_continuous(name='Dispersion\n(Max RPE - Min RPE) / RPE') +
  coord_flip()

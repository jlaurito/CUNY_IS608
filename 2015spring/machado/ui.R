

# The line below sets the working directory for Shiny server.# This is the user interface part of the script
#

library(shiny)

# The line below sets the working directory for Shiny server.
# Please adjust this according to your file system.
setwd('C:/Temp/BIM_Project_608')

# We create a list of years to populate the Drop down box.
df <- read.csv('./data/SAP_500.csv', stringsAsFactors=FALSE, header=TRUE)
df <- cbind(df, Year=as.numeric(substr(df$Date, 1, 4)))
df<-df[df$Year>=1953 & df$Year<=2011,]

Years <- lapply(unique(df$Year), as.character)

# We will create drop downs with the years ranging from 1953 to 2011.
shinyUI(pageWithSidebar(
  headerPanel('Returns of SAP 500 for period 1953 to 2011 (Oct to Oct)'),
  sidebarPanel("Select the year range below: ", selectInput("startYear", "Start Year: ", choices=Years, selected='1953')
               ,selectInput("endYear", "End Year: ", choices=Years, selected='2011')
               ),
  mainPanel(plotOutput('values'),width = 500))
)


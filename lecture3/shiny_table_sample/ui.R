# This is the user interface part of the script
#

library(shiny)
setwd('~/Dropbox/CUNY/CUNY_IS608/lecture3/shiny_table_sample')

# let's create a list of potential states and years
mort_ui <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

states <- unique(mort_ui$State)
years  <- unique(mort_ui$Year)


# shiny UI
shinyUI(pageWithSidebar(
  headerPanel('Causes of Death, State and Year'),
  sidebarPanel(selectInput("state", "State: ", states, selected='Alabama'),
               selectInput("year", "Year: ", years, selected=1999)),
  mainPanel(tableOutput('values')))
)


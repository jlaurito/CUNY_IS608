# This is the user interface part of the script
#

library('shiny')
library('ggplot2')
setwd('~/Dropbox/CUNY/CUNY_IS608/lecture3/shiny_graph_sample')

# let's create a list of potential states and years
mort_ui <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

states <- unique(mort_ui$State)
cause  <- unique(mort_ui$ICD.Chapter)

# shiny UI
shinyUI(pageWithSidebar(
  headerPanel('Cause of Death by Year, by Type'),
  sidebarPanel(selectInput("state", "State: ", states, multiple=TRUE, selected='Alabama'),
               selectInput("cause", "Cause: ", cause, selected='Certain infectious and parasitic diseases')
              ),
  mainPanel(plotOutput('values')))
)


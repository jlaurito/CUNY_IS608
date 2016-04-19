# This is the user interface part of the script
#

library('shiny')
library('ggplot2')
#setwd('/Users/josh.laurito/src/CUNY_IS608/lecture3/shiny_graph_sample')

# let's create a list of potential states and years
mort_ui <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

states <- lapply(unique(mort_ui$State), as.character)
cause  <- lapply(unique(mort_ui$ICD.Chapter), as.character)

# shiny UI
shinyUI(pageWithSidebar(
  headerPanel('Cause of Death by Year, by Type'),
  sidebarPanel(selectInput("state", "State: ", choices=states, multiple=TRUE, selected='Alabama'),
               selectInput("cause", "Cause: ", choices=cause, selected='Certain infectious and parasitic diseases')
              ),
  mainPanel(plotOutput('values')))
)


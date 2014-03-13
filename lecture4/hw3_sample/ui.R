# This is the user interface part of the script
#

library('shiny')
library('ggplot2')
library('googleVis')
setwd('~/Dropbox/CUNY/CUNY_IS608/lecture4/hw3_sample')

# let's create a list of potential states and years
mort_ui <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

cause  <- data.frame(table(mort_ui$ICD.Chapter))[table(mort_ui$ICD.Chapter) >100, 1]

# shiny UI
shinyUI(pageWithSidebar(
  headerPanel('States Ranked by Relative Mortality'),
  sidebarPanel(selectInput("cause", "Cause: ", cause, selected='Certain infectious and parasitic diseases')
              ),
  mainPanel(
    tabsetPanel(
      tabPanel("2010 Rankings", htmlOutput('values')),
      tabPanel("Change Over Time", htmlOutput('motion'))
    )
  )
))
# This is the user interface part of the script
#

library('shiny')
library('ggplot2')
library('googleVis')

# let's create a list of potential states and years
mort_ui <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

cause  <- lapply(data.frame(table(mort_ui$ICD.Chapter))[table(mort_ui$ICD.Chapter) >100, 1],as.character)


# shiny UI
fluidPage(
  titlePanel('States Ranked by Relative Mortality'),
  sidebarLayout(
    sidebarPanel(selectInput("cause", "Cause: ", 
                           cause, selected='Certain infectious and parasitic diseases')
                ),
    mainPanel(
      tabsetPanel(
        tabPanel("2010 Rankings", htmlOutput('values')),
        tabPanel("Change Over Time", htmlOutput('motion'))
      )
    ),
  fluid=FALSE
  )
)
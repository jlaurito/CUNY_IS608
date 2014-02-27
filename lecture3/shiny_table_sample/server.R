# This script determines what the server does.
# 

library(shiny)
library(plyr)
setwd('~/Dropbox/CUNY/CUNY_IS608/lecture3/shiny_table_sample')

# load data
mort <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

# let's just get the 'crude rate' of deaths for one state
# in one year
shinyServer(function(input, output){
  
  subsetAndOrder <- function(df){
    # subset
    dfOut <- subset( df, 
                     State==input$state & 
                     Year==input$year,
                     select=c('ICD.Chapter',
                              'Deaths',
                              'Crude.Rate')
              )
    # order and clear row names
    dfOut <- dfOut[order(-dfOut$Crude.Rate),]
    row.names(dfOut) <- NULL
    return(dfOut)
  }
  
  
  # push to output for display
  output$caption <- renderText(input$state)
  output$values <- renderTable(subsetAndOrder(mort)
                               )
})

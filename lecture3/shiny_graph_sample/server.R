# This script determines what the server does.
# 

library('shiny')
library('plyr')
library('ggplot2')
#setwd('/Users/josh.laurito/src/CUNY_IS608/lecture3/shiny_graph_sample')

# load data
mort <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

# let's just get the 'crude rate' of deaths for one state
# in one year
shinyServer(function(input, output){
  
  outputPlot <- function(){
    # subset
    in_state <- input$state

    in_cause <- input$cause
    slcted <- mort[mort$State %in% in_state & mort$ICD.Chapter==in_cause, 
                   c('ICD.Chapter','State','Year','Crude.Rate')
                  ]

    p <- ggplot(slcted, aes(x=Year, y=Crude.Rate, group=State)) +
         geom_line(aes(color=State)) + xlab(in_cause)
    print(p)
  }

  
  # push to output for display
  output$values <- renderPlot(outputPlot())
})

# This script determines what the server does.
# 

library('shiny')
library('plyr')
library('ggplot2')
setwd('~/Dropbox/CUNY/CUNY_IS608/lecture4/hw3_sample')

# load data
mort <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

# let's just get the 'crude rate' of deaths for one state
# in one year
shinyServer(function(input, output){
  
  outputPlot <- function(){
    # subset
    in_cause <- input$cause
    slcted <- mort[mort$Year == 2010 & mort$ICD.Chapter==in_cause, 
                   c('State','Crude.Rate', 'Population')
                  ]
    slcted <- slcted[with(slcted, order(-Crude.Rate)),]
    slcted$State.Rank <- rank(-slcted$Crude.Rate, ties.method="random")

    gvisBubbleChart(slcted, 
                    idvar='State', 
                    xvar='Crude.Rate', 
                    yvar='State.Rank',
                    sizevar='Population',
                    options= list(chartArea='{left:0,top:0,width:600,height:900}', 
                                  colorAxis.legend.position='none',
                                  fontSize=9,
                                  vAxis='{direction:-1, maxValue:52, 
                                          minValue:0, gridlines:{count:0}}',
                                  hAxis=paste('{minValue:0,maxValue:',
                                              slcted$Crude.Rate[1]*1.1,
                                              ',gridlines:{count:0}}',
                                              sep=''),
                                  sizeAxis='{maxValue:40000000, minValue:500000,
                                             maxSize:4, minSize:2}'
                                 )
                    )
  }
  
  motionPlot <- function(){
    # subset
    in_cause <- input$cause
    motion <- mort[mort$ICD.Chapter==in_cause, 
                   c('State','Crude.Rate', 'Year','Population', 'Deaths')
                   ]
    
    # weighted Average
    motion$Average <- daply(motion, 
                            .(Year), 
                            function(x) weighted.mean(x$Crude.Rate, x$Population))
    motion$Best <- daply(motion, .(Year),function(x) min(x$Crude.Rate))
    motion$Deviation.From.Average <- motion$Crude.Rate - motion$Average
    motion$Deviation.From.Best <- motion$Best - motion$Crude.Rate
    
    gvisMotionChart(motion, 
                    idvar='State', 
                    timevar='Year',
                    xvar='Deaths', 
                    yvar='Deviation.From.Average',
                    sizevar='Population',
                    options= list(chartArea='{left:0,top:0,width:600,height:900}', 
                                  colorAxis.legend.position='none',
                                  state='{"showTrails":true};')
    )
    
  }

  # push to output for display
  output$values <- renderGvis(outputPlot())
  output$motion <- renderGvis(motionPlot())
})

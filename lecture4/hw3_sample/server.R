# This script determines what the server does.
# 

library('shiny')
library('plyr')
library('ggplot2')

# load data
mort <- read.csv('../data/cleaned-cdc-mortality-1999-2010.csv')

# let's just get the 'crude rate' of deaths for one state
# in one year
shinyServer(function(input, output){
  
  outputPlot <- function(){
    # subset
    in_cause <- input$cause
    #in_cause <- "Neoplasms"
    slcted <- mort[mort$Year == 2010 & mort$ICD.Chapter==in_cause, 
                   c('State','Crude.Rate', 'Population')
                  ]
    slcted <- slcted[with(slcted, order(-Crude.Rate)),]
    slcted$State.Rank <- rank(-slcted$Crude.Rate, ties.method="random")
    slcted$State <- sapply(slcted$State, as.character)
    
    gvisBubbleChart(slcted, 
                    idvar='State', 
                    xvar='Crude.Rate', 
                    yvar='State.Rank',
                    sizevar='Population',
                    options= list(chartArea='{width:600,height:"100%"}',
                                  height=600,
                                  colorAxis.legend.position='none',
                                  vAxis='{direction:-1, maxValue:52, 
                                          minValue:0, gridlines:{count:0}}',
                                  hAxis=paste('{minValue:0,maxValue:',
                                              slcted$Crude.Rate[1]*1.1,
                                              ',gridlines:{count:0}}',
                                              sep=''),
                                  sizeAxis='{maxSize:3, minSize:3}'
                                  , bubble='{textStyle: {fontSize: 8,color:"black"}}'
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
    motion$Deviation.From.Best <- motion$Crude.Rate - motion$Best
    
    gvisMotionChart(motion, 
                    idvar='State', 
                    timevar='Year',
                    xvar='Deaths', 
                    yvar='Deviation.From.Average',
                    sizevar='Population',
                    options= list(chartArea='{left:0,top:0,width:600,height:900}', 
                                  colorAxis.legend.position='none',
                                  state='{"time":"2004","orderedByX":false,"playDuration":15000,"uniColorForNonSelected":false,"yAxisOption":"4","colorOption":"4","xLambda":1,"xAxisOption":"2","iconType":"BUBBLE","yZoomedDataMax":44.8,"dimensions":{"iconDimensions":["dim0"]},"xZoomedDataMax":9615,"iconKeySettings":[{"key":{"dim0":"New York"},"trailStart":"1999"}],"nonSelectedAlpha":0.4,"sizeOption":"5","duration":{"multiplier":1,"timeUnit":"Y"},"yLambda":1,"yZoomedIn":false,"showTrails":true,"xZoomedIn":false,"xZoomedDataMin":102,"orderedByY":false,"yZoomedDataMin":16.3};')
    )
    
  }

  # push to output for display
  output$values <- renderGvis(outputPlot())
  output$motion <- renderGvis(motionPlot())
})

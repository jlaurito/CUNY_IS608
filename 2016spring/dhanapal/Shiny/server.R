

library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)

setwd("C:/Senthil/MSDataAnalytics/Semester3/608/Project")

dataLoadAndCleanup <- function()
{
  
  dfDefault <- read.csv(file='default of credit card clients.csv', stringsAsFactors = FALSE)
  
  names(dfDefault) <- tolower(names(dfDefault))
  
  dfDefault <- transform(dfDefault, id <- as.numeric(id), 
                         limit_bal <- as.numeric(limit_bal), 
                         age <- as.numeric(age),
                         education <- as.numeric(education),
                         pay_0 <- as.numeric(pay_0),
                         pay_2 <- as.numeric(pay_2),
                         pay_3 <- as.numeric(pay_3),
                         pay_4 <- as.numeric(pay_4),
                         pay_5 <- as.numeric(pay_5),
                         pay_6 <- as.numeric(pay_5),
                         bill_amt1 <- as.numeric(bill_amt1), 
                         bill_amt2 <- as.numeric(bill_amt2), 
                         bill_amt3 <- as.numeric(bill_amt3), 
                         bill_amt4 <- as.numeric(bill_amt4), 
                         bill_amt5 <- as.numeric(bill_amt5), 
                         bill_amt6 <- as.numeric(bill_amt6), 
                         pay_amt1 <- as.numeric(pay_amt1), 
                         pay_amt2 <- as.numeric(pay_amt2), 
                         pay_amt3 <- as.numeric(pay_amt3), 
                         pay_amt4 <- as.numeric(pay_amt4), 
                         pay_amt5 <- as.numeric(pay_amt5), 
                         pay_amt6 <- as.numeric(pay_amt6) 
  )
  names(dfDefault)[13:18] <- c('sep_bill_amt', 'aug_bill_amt', 'jul_bill_amt', 'jun_bill_amt', 'may_bill_amt', 'apr_bill_amt')
  names(dfDefault)[19:24] <- c('sep_pay_amt', 'aug_pay_amt', 'jul_pay_amt', 'jun_pay_amt', 'may_pay_amt', 'apr_pay_amt')
  
  names(dfDefault)[25] <- c('default.expected')
  
  #Convert numbers to actual values for sex
  dfDefault$sex[which(dfDefault$sex==1)] <- 'Male'
  dfDefault$sex[which(dfDefault$sex==2)] <- 'Female'
  
  #Convert numbers to actual values for education
  dfDefault$education[which(dfDefault$education==1)] <- 'Graduate'
  dfDefault$education[which(dfDefault$education==2)] <- 'University'
  dfDefault$education[which(dfDefault$education==3)] <- 'HighSchool'
  dfDefault$education[which(dfDefault$education==4)] <- 'Others'
  dfDefault$education[which(dfDefault$education==5)] <- 'Others'
  dfDefault$education[which(dfDefault$education==6)] <- 'Others'
  dfDefault$education[which(dfDefault$education==0)] <- 'Others'
  
  #Convert numbers to actual values for marital status
  dfDefault$marriage[which(dfDefault$marriage==1)] <- 'Married'
  dfDefault$marriage[which(dfDefault$marriage==2)] <- 'Single'
  dfDefault$marriage[which(dfDefault$marriage==3)] <- 'Others'
  dfDefault$marriage[which(dfDefault$marriage==0)] <- 'Others'
  
  return (dfDefault)
}


meltData <- function(df)
{
  df1 <- df %>% select(id,sex,marriage,education,default.expected)
  df1Melted <- melt(df1,id=c('id','default.expected'))
  df1Melted$value <- as.character(df1Melted$value)
  return (df1Melted)
}


dfDefault <- dataLoadAndCleanup()
dfMelted <- meltData(dfDefault)



shinyServer(
  
  function(input, output) 
  {
    
    output$barplot1 <- renderPlot({
      
      #colNums <- match(c(input$type,'default.expected'),names(dfDefault))
      #dfForPlotting <- dfDefault %>% select(colNums) %>% group_by()
      
      inputtype = input$type
      if(inputtype=='gender')
      {
        inputtype = 'sex'
      }
      title <- paste('Total Members vs Defaulters by ',input$type)
      dfPlotData1 <- dfMelted %>% filter(as.character(variable)==inputtype) %>% group_by(groupedOn=value) %>% 
        summarize(DefaultExpected = sum(default.expected), CardHolders=n()) 
      dfPlotData <- melt(dfPlotData1,id=c('groupedOn'))  
      
      dfPlotData$groupedOn <- factor(dfPlotData$groupedOn)
      level <- dfPlotData[order(-dfPlotData$value[dfPlotData$variable=='DefaultExpected']),1]
      dfPlotData$groupedOn <- factor(dfPlotData$groupedOn, levels = level )
      
      ggplot(dfPlotData,aes(x=groupedOn,fill=factor(variable),y=value)) + geom_bar(stat='identity',position = 'dodge') + 
        xlab(input$type) + ggtitle(title) + theme(plot.title=element_text(family="Times", face="bold"))
      
    })
    
    output$barplot2 <- renderPlot({
      
      inputtype = input$type
      if(inputtype=='gender')
      {
        inputtype = 'sex'
      }
      title <- paste('Percentage of Defaulters to CreditCard Holders by ',input$type)
      dfPlotData1 <- dfMelted %>% filter(as.character(variable)==inputtype) %>% group_by(groupedOn=value) %>% summarize(PercentDefaulters=(sum(default.expected)/n())*100) 
      dfPlotData <- dfPlotData1
      
      dfPlotData$groupedOn <- factor(dfPlotData$groupedOn)
      level <- dfPlotData[order(-dfPlotData$PercentDefaulters),1]$groupedOn
      dfPlotData$groupedOn <- factor(dfPlotData$groupedOn, levels = level )
      
      ggplot(dfPlotData,aes(x=groupedOn,y=PercentDefaulters)) + geom_bar(stat='identity') + xlab(input$type) + ggtitle(title)+ theme(plot.title=element_text(family="Times", face="bold"))
      
    })
    
  }
  
)
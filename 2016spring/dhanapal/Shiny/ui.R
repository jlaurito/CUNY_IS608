### Demographical analysis of Members vs Defaulters

library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)


types <- c('gender', 'education', 'marriage')

#setwd("C:/Senthil/MSDataAnalytics/Semester3/608/Project")

shinyUI(
  pageWithSidebar(
    headerPanel('Demographical analysis of Members vs Defaulters'),
    sidebarPanel(
      selectInput(inputId = 'type', label = 'Choose a type of information',choices = types)
    ),
    
    mainPanel(
      plotOutput(outputId = 'barplot1'),
      plotOutput(outputId = 'barplot2')
    )
  )
)

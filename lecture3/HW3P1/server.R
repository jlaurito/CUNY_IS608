require(shiny)
require(ggplot2)


data <- read.csv('data/cleaned-cdc-mortality-1999-2010.csv', header = TRUE)
data <- data[data$Year == 2010,]

shinyServer(
  function(input, output) {
    
    dataSubset <- reactive({
      df <- subset(data, data$ICD.Chapter == input$disease)
      df$State <- reorder(df$State, 1 / df$Crude.Rate)
#       df <- df[order(df$Crude.Rate, decreasing = TRUE), ]
      df
    })
    
    output$plot <- renderPlot({
      
      ggplot(dataSubset(), aes(x = State, y = Crude.Rate)) + 
        geom_bar(stat = 'identity', fill = 'navy') +
        geom_text(aes(x = State, y = 0, ymax = Crude.Rate,
                      label=State, hjust = 1, vjust = 0.25), 
                  position = position_dodge(width=1),
                  color = 'white',
                  angle = 270,
                  size = 4) +
        scale_x_discrete(breaks = NULL) +
        theme(panel.background = element_rect(fill = 'darkgray'))
        
    })
    
  }  
)
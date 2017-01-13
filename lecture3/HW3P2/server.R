require(shiny)
require(ggplot2)
require(dplyr)


data <- read.csv('data/cleaned-cdc-mortality-1999-2010.csv', header = TRUE)
natl <- data[, c(3, 5, 7, 9, 10)] %>% group_by(ICD.Chapter, Year) %>%
  summarize(Rate = 1e5 * sum(Deaths) / sum(Population))

shinyServer(
  function(input, output) {
    
    dataSubset1 <- reactive({
      subset(data, data$State %in% input$states)
    })
    
    dataSubset2 <- reactive({
      df <- dataSubset1()
      subset(df, df$ICD.Chapter == input$disease)
    })
    
    dataNatl <- reactive({
      subset(natl, natl$ICD.Chapter == input$disease)
    })
    
    inputStates <- reactive({
      input$states
    })
    
    output$plot <- renderPlot({
      
      out <- dataSubset2()
      
      ggplot(out, aes(x = Year, y = Crude.Rate, color = State)) + 
        geom_smooth(data = dataNatl(), aes(x = Year, y = Rate, color='0'), 
                  linetype = 2, size = 1.5, method = 'loess', fill=NA) +
        geom_smooth(size = 0.75, method = 'loess', fill=NA) +
        scale_color_discrete(labels = c('National', inputStates())) +
        theme_bw()
    })
    
  }  
)
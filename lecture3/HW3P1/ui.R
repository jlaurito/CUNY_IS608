shinyUI(
  fluidPage(
    titlePanel('Crude rate of disease by state'),
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput(
          'disease',
          label = 'Please select the disease for which you would like to see state rankings:',
          choices = c('Certain infectious and parasitic diseases',
                      'Neoplasms',
                      'Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism',
                      'Endocrine, nutritional and metabolic diseases',
                      'Mental and behavioural disorders',
                      'Diseases of the nervous system',
                      'Diseases of the ear and mastoid process',
                      'Diseases of the circulatory system',
                      'Diseases of the respiratory system',
                      'Diseases of the digestive system',
                      'Diseases of the skin and subcutaneous tissue',
                      'Diseases of the musculoskeletal system and connective tissue',
                      'Diseases of the genitourinary system',
                      'Pregnancy, childbirth and the puerperium',
                      'Certain conditions originating in the perinatal period',
                      'Congenital malformations, deformations and chromosomal abnormalities',
                      'Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified',
                      'External causes of morbidity and mortality'),
          selected = 'Neoplasms'
          
        )
      ),
      
      mainPanel(
        plotOutput('plot')
      )
    )
    
  )  
)
shinyUI(
  fluidPage(
    titlePanel('Rate of change in disease incidence vs national rate'),
    
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
          
        ),
        
        checkboxGroupInput(
          'states',
          label = 'Please choose which states to include in the graphic:',
          choices = c('Alabama',
                      'Alaska',
                      'Arizona',
                      'Arkansas',
                      'California',
                      'Colorado',
                      'Connecticut',
                      'Delaware',
                      'District of Columbia',
                      'Florida',
                      'Georgia',
                      'Hawaii',
                      'Idaho',
                      'Illinois',
                      'Indiana',
                      'Iowa',
                      'Kansas',
                      'Kentucky',
                      'Louisiana',
                      'Maine',
                      'Maryland',
                      'Massachusetts',
                      'Michigan',
                      'Minnesota',
                      'Mississippi',
                      'Missouri',
                      'Montana',
                      'Nebraska',
                      'Nevada',
                      'New Hampshire',
                      'New Jersey',
                      'New Mexico',
                      'New York',
                      'North Carolina',
                      'North Dakota',
                      'Ohio',
                      'Oklahoma',
                      'Oregon',
                      'Pennsylvania',
                      'Rhode Island',
                      'South Carolina',
                      'South Dakota',
                      'Tennessee',
                      'Texas',
                      'Utah',
                      'Vermont',
                      'Virginia',
                      'Washington',
                      'West Virginia',
                      'Wisconsin',
                      'Wyoming'
          ),
          selected = 'Alabama'
        )
      ),
        
      
      mainPanel(
        plotOutput('plot')
      )
    )
    
  )  
)
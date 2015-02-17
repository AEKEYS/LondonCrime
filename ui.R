library(shiny); require(rCharts)
options(RCHART_LIB='morris')

#User Interface file for Shiny App.
#User selects a Borough and an employment rate to compare with crime for that area.
#Figures are expressed as a percentage of the selected Borough's population.

## ui.R
shinyUI(pageWithSidebar(
    
    # Application Title
    headerPanel("London Crime & Employment"),
    
    sidebarPanel(
        selectInput("borough", 
                    label = "Select Borough to analyze:", 
                    choices = sort(unique(as.character(crimeEmployment$Borough))), 
                    selected = "Barking and Dagenham"),
        radioButtons("type", label = "Select variable for crime comparison:",
                     choices = sort(names(crimeEmployment)[5:7]),
                     selected = "Employment"),
        submitButton('Submit'),
        h4("Data obtained from London.gov.uk")
    ),
    mainPanel(
        h3("Showing rates as a percentage of population for:"),
        verbatimTextOutput("inputBorough"),
        showOutput('newChart','morris'), #defined in server.R
        h3("Population by Year"),
        tableOutput('view')
        #imageOutput("mapImage")
    )
))
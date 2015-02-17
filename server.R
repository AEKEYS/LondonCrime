library(shiny); require(rCharts); require(dplyr)
options(RCHART_WIDTH = 800)

#This file is for the Shiny App server calculations.
#It receives input from and outputs to the UI file.

##### server.R #####

shinyServer(
    function(input,output) {
        output$inputBorough <- renderPrint({input$borough})
        output$inputType <- renderPrint({input$type})
        output$newChart <- renderChart2({
            #morris-style plot
             data <- transform(crimeEmployment, date=as.character(Year))
             m1 <- mPlot(x="date",y=c(input$type,"Crime"),type="Line",
                         data=subset(data, Borough==input$borough))
            return(m1)
        })
        output$view <- renderTable({
            dcast(subset(crimeEmployment, Borough==input$borough), 
                  Borough~as.integer(Year), 
                  value.var = "Population")
        })
        #Not currently displayed in the UI
        output$mapImage <- renderImage({
            list(src = "boroughs.png",
                 alt = "Borough Map",
                 width=800)
            
        }, deleteFile = FALSE)
        
    }
)
library(shiny); require(rCharts); require(dplyr)
options(RCHART_WIDTH = 800)

#source("londonData.R")

##### visuals ####

suppressPackageStartupMessages(library(googleVis))
M <- gvisMotionChart(crimeEmployment, 'Borough','Year', options = list(width=600, height=400))
# plot(M)
# print(M, "chart") #if using in slidify


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
        
        output$mapImage <- renderImage({
            list(src = "boroughs.png",
                 alt = "Borough Map",
                 width=800)
            
        }, deleteFile = FALSE)
        
    }
)
# LondonCrime

*Overview:* This repo contains the files necessary to run ["London Crime & Employment"](https://aekeys.shinyapps.io/LondonCrime/), a Shiny App created for the Johns Hopkins University's ["Developing Data Products"](https://www.coursera.org/course/devdataprod) class offered through Coursera.

##FUNCTIONALITY
The app enables users to select a London borough and then compare that area's crime rate with an employment rate of their choosing (employment, unemployment, and youth unemployment).

Based on the user's selections, the app displays an interactive chart with the crime and employment rates expressed as a percentage of the selected borough's population in each year in the range (2005-2013).

##DATA FILES, METHODOLOGY
Data were obtained from London.gov.uk's ["Datastore"](http://data.london.gov.uk/dataset/london-borough-profiles).
+The file **Global.R** describes how the data were downselected and cleaned for use by the app.
+The file **UI.R** contains the code Shiny uses to generate the app's user interface and specifies user controls.
+The file **Server.R** contains the code Shiny uses to run calculations based on the user's input. It implements an rCharts interactive chart using the morris library.
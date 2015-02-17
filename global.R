#This file reads in and cleans up the data for use by
#both the UI and Server files (Shiny App).

library(reshape2); library(tidyr); library(dplyr)

# Original data obtained from:
url <- "http://data.london.gov.uk/dataset/london-borough-profiles/resource/445fbb06-8945-499b-b1e6-1933afa3c642"
# I selected population, crime, employment, and wellbeing columns from sheets 1 and 2 and saved to CSV

#####READ IN DATA####

boroughs <- read.csv("almanacSubset.csv",
                     header=TRUE,
                     stringsAsFactors = FALSE,
                     #nrows=1,
                     na.strings="-",
                     colClasses=c("character","character",rep("numeric",times=59)))

####DATA CLEAN UP####

names(boroughs)[1:2] <- c("Borough","InnerOuter")

# Melt or "gather" variable columns into one with a value column
boroughs <- melt(boroughs, id=c("Borough","InnerOuter"),
                 variable.name="type_year",
                 value.name="Value")

# Separate type_year column into two
boroughs <- separate(boroughs, type_year, into=c("Type","Year"))

## Need to "dcast" type (create new variables for each type with values)
boroughs <- dcast(boroughs, Borough + InnerOuter + Year ~ Type,
                  value.var = "Value")
boroughs$Year <- as.numeric(boroughs$Year)

crimeEmployment <- boroughs[,c("Borough","InnerOuter","Year","Pop","Employ","Unemploy","YouthUnemploy","Crime")]

mentalWellbeing <- boroughs[,c("Borough","InnerOuter","Year","Happiness","Satisfaction","Worthwhileness")]
mentalWellbeing <- mentalWellbeing[which(mentalWellbeing$Year>2011),]

#City of London is missing Happiness and Satisfaction scores for 2012. Use its average for each.
mentalWellbeing[mentalWellbeing$Borough=="City of London",4] <- mean(mentalWellbeing$Happiness[mentalWellbeing$Borough=="City of London"],na.rm = TRUE)
mentalWellbeing[mentalWellbeing$Borough=="City of London",5] <- mean(mentalWellbeing$Satisfaction[mentalWellbeing$Borough=="City of London"],na.rm = TRUE)

mentalWellbeing$Borough <- as.factor(mentalWellbeing$Borough)
mentalWellbeing$InnerOuter <- as.factor(mentalWellbeing$InnerOuter)

#2014 employment and crime numbers not avail for all boroughs, so I remove that year.
crimeEmployment <- crimeEmployment[crimeEmployment$Year<2014,]

#Crime and employment numbers not avail for City of London, so I remove it.
crimeEmployment <- crimeEmployment[-c(which(crimeEmployment$Borough=="City of London")), ]

#Kensington and Chelsea in 2005 and Richmond upon Thames 2013 are missing YouthUnemploy, use respective averages for avail years
crimeEmployment[crimeEmployment$Borough=="Kensington and Chelsea", 7] <- mean(crimeEmployment$YouthUnemploy[crimeEmployment$Borough=="Kensington and Chelsea"],na.rm=TRUE)
crimeEmployment[crimeEmployment$Borough=="Richmond upon Thames", 7] <- mean(crimeEmployment$YouthUnemploy[crimeEmployment$Borough=="Richmond upon Thames"],na.rm=TRUE)

crimeEmployment$Borough <- as.factor(crimeEmployment$Borough)
crimeEmployment$InnerOuter <- as.factor(crimeEmployment$InnerOuter)

names(crimeEmployment) <- c("Borough","InnerOuter","Year","Population","Employment","Unemployment","Youth_Unemployment","Crime")
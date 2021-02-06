library(dplyr)
library(downloader)
library(tidyr)
library(lubridate)

dataURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download(dataURL, dest="./dataset.zip", mode="wb") 
#Unzip the newly downloaded file in the created working directory for this assignment
unzip ("./dataset.zip")

data<-data.frame(read.table("household_power_consumption.txt", sep = ";", header = T))
data<-data %>% unite(DateTime, Date, Time, sep = " ", remove = F)

#we only need data from 2007-02-01 and 2007-02-02
data$DateTime<-dmy_hms(data$DateTime)
data$Date<-dmy(data$Date)
targetdate<-c(dmy("01-02-2007"), dmy("02-02-2007"))
subdata<-filter(data, Date %in% targetdate)
rm(data);rm(targetdate)
subdata<-select(subdata, -Date, -Time)

#Plot 1 is a histogram of Global active power in kilowatts
subdata$Global_active_power<-as.numeric(subdata$Global_active_power)

png("plot1.png", width = 480,height = 480)
hist(subdata$Global_active_power, col = "red", xlab = "Global active power (kilowatts)", main = "Global Active Power")
dev.off()


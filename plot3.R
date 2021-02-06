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

#Plot 3 is Energy Sub metering 1, 2, 3
subdata$Sub_metering_1<-as.numeric(subdata$Sub_metering_1)
subdata$Sub_metering_2<-as.numeric(subdata$Sub_metering_2)
subdata$Sub_metering_3<-as.numeric(subdata$Sub_metering_3)

png("plot3.png", width = 480,height = 480)
with(subdata, 
        plot(DateTime, Sub_metering_1, type='l', xlab = '', ylab='Energy sub metering')+
             lines(DateTime, Sub_metering_2, col = "red")+
             lines(DateTime, Sub_metering_3, col = "blue")+
             legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty = 1)
     )
dev.off()
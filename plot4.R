## Run as script.

fileUrl <- ("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
fileZip <- "exdata_data_household_power_consumption.zip"
fileTxt <- "household_power_consumption.txt"

setAs("character","myDate",function(from) as.Date(from, format="%d/%m/%Y"))
setClass("myDate") 
colClasses <- c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

if(!file.exists(fileZip)) {
        download.file(fileUrl, fileDest)
}

unzip(fileZip, exdir=".")
fileData <- read.table(fileTxt, sep=";", header=TRUE, 
        na.strings="?", colClasses=colClasses, comment.char = "",nrows=2075259)

dates <- c(as.Date("1/2/2007", format="%d/%m/%Y"),as.Date("2/2/2007", format="%d/%m/%Y"))

filteredData <- subset(fileData,fileData$Date %in% dates)
filteredData2 <- subset(filteredData,filteredData$Global_active_power != "?")
filteredData3 <- subset(filteredData,filteredData$Sub_metering_1 != "?")
filteredData4 <- subset(filteredData,filteredData$Sub_metering_2 != "?")
filteredData5 <- subset(filteredData,filteredData$Sub_metering_3 != "?")
filteredData6 <- subset(filteredData,filteredData$Voltage != "?")
filteredData7 <- subset(filteredData,filteredData$Global_reactive_power != "?")

gooddata <- data.frame(as.POSIXct(paste(filteredData2$Date,filteredData2$Time,sep=" ")),filteredData2$Global_active_power)
cnames <- c("datetime","data")
colnames(gooddata) <- cnames

gooddata2 <- data.frame(as.POSIXct(paste(filteredData3$Date,filteredData3$Time,sep=" ")),filteredData3$Sub_metering_1)
gooddata3 <- data.frame(as.POSIXct(paste(filteredData4$Date,filteredData4$Time,sep=" ")),filteredData4$Sub_metering_2)
gooddata4 <- data.frame(as.POSIXct(paste(filteredData5$Date,filteredData5$Time,sep=" ")),filteredData5$Sub_metering_3)
gooddata5 <- data.frame(as.POSIXct(paste(filteredData6$Date,filteredData6$Time,sep=" ")),filteredData6$Voltage)
gooddata6 <- data.frame(as.POSIXct(paste(filteredData7$Date,filteredData7$Time,sep=" ")),filteredData7$Global_reactive_power)

colnames(gooddata2) <- cnames
colnames(gooddata3) <- cnames
colnames(gooddata4) <- cnames
colnames(gooddata5) <- cnames
colnames(gooddata6) <- cnames

## plot2.R and plot3.R plus 2 new plots
png(file="plot4.png", height=480, width=480)
par(mfrow=c(2,2)) 
plot(gooddata$datetime,gooddata$data,xlab="",ylab="Global Active Power", type="l")
plot(gooddata5$datetime,gooddata5$data,xlab="datetime",ylab="Voltage", type="l")
plot(gooddata2$datetime,gooddata2$data,xlab="",ylab="Energy sub metering", type="l", col="black")
lines(gooddata3$datetime,gooddata3$data,col="red")
lines(gooddata4$datetime,gooddata4$data,col="blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1, bty="n", col=c("black","red","blue"))
plot(gooddata6$datetime,gooddata6$data,xlab="datetime",ylab="Global_reactive_power", type="l")
dev.off()

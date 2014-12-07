## Run as script

fileUrl <- ("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
fileZip <- "exdata_data_household_power_consumption.zip"
fileTxt <- "household_power_consumption.txt"

# Get file

setAs("character","myDate",function(from) as.Date(from, format="%d/%m/%Y"))
setClass("myDate") 
colClasses <- c("myDate","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

if(!file.exists(fileZip)) {
        download.file(fileUrl, fileDest)
}

# Unzip and read file

unzip(fileZip, exdir=".")
fileData <- read.table(fileTxt, sep=";", header=TRUE, 
        na.strings="?", colClasses=colClasses, comment.char = "",nrows=2075259)

# Filter data for 2 dates to be interrogated

dates <- c(as.Date("1/2/2007", format="%d/%m/%Y"),as.Date("2/2/2007", format="%d/%m/%Y"))
filteredData <- subset(fileData,fileData$Date %in% dates)
filteredData3 <- subset(filteredData,filteredData$Sub_metering_1 != "?")
filteredData4 <- subset(filteredData,filteredData$Sub_metering_2 != "?")
filteredData5 <- subset(filteredData,filteredData$Sub_metering_3 != "?")
gooddata2 <- data.frame(as.POSIXct(paste(filteredData3$Date,filteredData3$Time,sep=" ")),filteredData3$Sub_metering_1)
gooddata3 <- data.frame(as.POSIXct(paste(filteredData4$Date,filteredData4$Time,sep=" ")),filteredData4$Sub_metering_2)
gooddata4 <- data.frame(as.POSIXct(paste(filteredData5$Date,filteredData5$Time,sep=" ")),filteredData5$Sub_metering_3)
colnames(gooddata2) <- cnames
colnames(gooddata3) <- cnames
colnames(gooddata4) <- cnames

# Plot

png(file="plot3.png", height=480, width=480)
plot(gooddata2$datetime,gooddata2$data,xlab="",ylab="Energy sub metering", type="l", col="black")
lines(gooddata3$datetime,gooddata3$data,col="red")
lines(gooddata4$datetime,gooddata4$data,col="blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1, col=c("black","red","blue"))
dev.off()

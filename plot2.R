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
filteredData2 <- subset(filteredData,filteredData$Global_active_power != "?")

gooddata <- data.frame(as.POSIXct(paste(filteredData2$Date,filteredData2$Time,sep=" ")),filteredData2$Global_active_power)
cnames <- c("datetime","data")
colnames(gooddata) <- cnames

# Plot

png(file="plot2.png", height=480, width=480)
plot(gooddata$datetime,gooddata$data,xlab="",ylab="Global Active Power (kilowatts)", type="l")
dev.off()

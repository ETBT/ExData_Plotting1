#check to see if zip file exists. If not, then download, extract and delete it.
if(!file.exists("exdata-data-household_power_consumption.zip")) {
      temp <- tempfile()
      download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
      file <- unzip(temp)
      unlink(temp)
      rm(file,temp)
}


#Do an initial read of the large data table to determine the column classes. Assign these classes to a variable.
initial <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, nrows = 10000, na.strings = "?")   #read the first 1000 rows of data.
classes <- sapply(initial,class)
rm(initial)

#Read in the full set of data using the classes variable determined in the step above.
fullset <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, colClasses = classes, na.strings = "?")
rm(classes)

#Re-format the Date column to be of the date class.
fullset$Date <- as.Date(fullset$Date, format="%d/%m/%Y")

#Subset the data to use only the dates relevant to the assignment.
df <- fullset[(fullset$Date=="2007-02-01") | (fullset$Date=="2007-02-02"),]
rm(fullset)

#Create a timestamp column combining Date and Time.
df <- transform(df, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")


#Create a png for the fourth plot.
png(filename="plot4.png", width=480, height=480)

#configure the space for the 4th plot, which is a 2x2 containing 4 plots
par(mfcol = c(2,2))

#plot 1
plot(df$timestamp, df$Global_active_power, type="l", xlab = "", ylab = "Global Active Power (kilowatts)")

#plot 2
plot(df$timestamp, df$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(df$timestamp, df$Sub_metering_2, col="red")
lines(df$timestamp, df$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lwd=par("lwd"))

#plot 3
plot(df$timestamp, df$Voltage, type="l",
     xlab="datetime", ylab="Voltage")

#plot 4
plot(df$timestamp, df$Global_reactive_power, type="l",
     xlab="datetime", ylab="Global_reactive_power")

dev.off()



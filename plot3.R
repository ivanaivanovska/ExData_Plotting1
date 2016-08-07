library(data.table)
library(utils)

# download and unzip data file, if it is not in the working dir ----------------
txtFile <- "household_power_consumption.txt" 
zipFile = "exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists(txtFile))
{
        if(!file.exists(zipFile)) {
                retval = download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                                       destfile = zipFile)
        }
        unzip(zipfile=zipFile)
}



# Read only data from the dates 2007-02-01 and 2007-02-02 ----------------------

# Total number of rows
nbRows <- 2075259 

# Number of lines to be read
nblines <- 2880

# Start reading at row:
startRow <- 66637

# nblines and startRow are calculated with the following code, 
# commented out because of speed:

## Read records starting at 01/02/2007
# d1<-fread(txtFile, skip = "1/2/2007", sep=";", na.strings = "?", header=TRUE)

## Read records starting at 03/02/2007
# d2<-fread(txtFile, skip = "3/2/2007", sep=";", na.strings = "?", header=TRUE)

## Calc. number of lines to be read
# nblines <- nrow(d1) - nrow(d2)

## Calc. starting row as: total nb. rows - nb. rows in d1
# startRow = nbRows - nrow(d1)


# Read header line, plus one line
header <- read.table(txtFile, nrow = 1, header = TRUE, sep=";")

# Read only data at the particular 2 dates.
d<-read.table(txtFile,
              skip = startRow, 
              nrow = nblines,
              sep=";",
              col.names = colnames(header),
              na.strings = "?")

# Convert to date and time
d$Date <- as.Date(d$Date, format = "%d/%m/%Y")
d$Time<-strptime(paste(d$Date, as.character(d$Time)), format="%Y-%m-%d %H:%M:%S")


# Generate Plot 3 --------------------------------------------------------------

with(d, plot(Time, Sub_metering_1, type="n", 
             ylab = "Energy Sub Metering", xlab=""))

with(d, points(Time, Sub_metering_1, type="l", col="black"))
with(d, points(Time, Sub_metering_2, type="l", col="red"))
with(d, points(Time, Sub_metering_3, type="l", col="blue"))
temp <- legend("topright", legend = c(" ", " ", " "),
               text.width = strwidth("1,000,000,000,000"),
               col=c("black","red", "blue"),
               lty=c(1,1,1), 
               y.intersp=0.8,
               xjust = 1, yjust = 1,
               cex=0.8)
text(temp$rect$left + temp$rect$w, temp$text$y,
     c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
     pos = 2)

# Save to png ------------------------------------------------------------------
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()

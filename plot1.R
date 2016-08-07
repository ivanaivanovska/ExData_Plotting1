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

# Generate Plot 1 --------------------------------------------------------------

hist(d$Global_active_power, 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", 
     col = "red")
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()
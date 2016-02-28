
# checkf for data and download
download.data = function() {
    "Checks for data directory and creates one if it doesn't exist"
    if (!file.exists("data")) {
        message("Creating data directory")
        dir.create("data")
    }
    if (!file.exists("data/UCI HAR Dataset")) {
        # download the data
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        zipfile="exdata%2Fdata%2FNEI_data.zip"
        message("Downloading data")
        download.file(fileURL, destfile=zipfile, method="curl")
        unzip(zipfile, exdir="data")
    }
}

if (!file.exists('data')){
 download.data()
}


NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# subset
subset <- subset(NEI, fips == "24510" )
emissionsAggregates <- aggregate(subset[, 'Emissions'], by=list(subset$year), FUN=sum)
names(emissionsAggregates) <- c('Year', 'PMaggregate')

# Generate plot
png(filename='plot2.png')

barplot(emissionsAggregates$PM, names.arg=emissionsAggregates$Year, 
        main=expression('Total Emission in Baltimore City, Maryland' ),
        xlab='Year', ylab=expression(paste('PM', ''[2.5], ' in tons')))

dev.off()


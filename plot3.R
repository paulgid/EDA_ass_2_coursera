
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

require(ggplot2)

NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


# subset to get data for Baltimore
subset <- subset(NEI, fips == "24510" )
subset$year <- as.factor(subset$year)

# generate plot

png(filename='plot3.png')

	ggplot(data=subset, aes(x=year, y=log(Emissions))) + facet_grid(. ~ type) + guides(fill=F) +
	    geom_boxplot(aes(fill=type)) + ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
	    ggtitle('Emissions by Type in Baltimore, Maryland') +
	    geom_jitter(alpha=0.20)

dev.off()

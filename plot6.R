
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

onRoad <- subset(NEI, type == 'ON-ROAD')
onRoad$year <- as.factor(onRoad$year)
onRoad$fips <- as.factor(onRoad$fips)

onRoad <- subset(onRoad, fips %in% c('24510', '06037'))


# create the plot 

png('plot6.png')

	ggplot(data=onRoad, aes(x=year, y=log(Emissions))) + facet_grid(. ~ fips) + guides(fill=F) +
	    geom_boxplot(aes(fill=fips)) + ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
	    ggtitle('Emissions of Motor Vehicle Sources\nLos Angeles County, California vs. Baltimore City, Maryland') +
	    geom_jitter(alpha=0.20)

dev.off()



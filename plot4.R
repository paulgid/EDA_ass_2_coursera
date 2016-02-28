
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

# merge the dataset
merged <- merge(x=NEI, y=SCC.coal, by='SCC')

# Coal combustion related sources aggreagate 
subset = merged[grepl("coal", merged$Short.Name, ignore.case=TRUE),]
emissionsAggregates <- aggregate(subset[, 'Emissions'], by=list(subset$year), FUN=sum)
names(emissionsAggregates) <- c('Year', 'PMaggregate')
#emissionsAggregates$PMaggregate <- round(emissionsAggregates$PMaggregate/1000,2)

# generate the plot

png(filename='plot4.png')

ggplot(data=emissionsAggregates.sum, aes(x=Year, y=Emissions/1000)) + 
    geom_line(aes(group=1, col=Emissions)) + geom_point(aes(size=2, col=Emissions)) + 
    ggtitle(expression('Total Emissions of PM'[2.5])) + 
    ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) + 
    geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) + 
    theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

dev.off()




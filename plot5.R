# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

library(dplyr)
library(ggplot2)

## Input:
# The data for this assignment are available from the course web site as a single zip file:
rawDataFileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# PM2.5 Emissions Data
filePathNEI <- "summarySCC_PM25.rds"
# Source Classification Code Table
filePathSCC <- "Source_Classification_Code.rds"
# check by calling dir() and see if those files are in the listing
if(length(dir(pattern=paste(filePathNEI, filePathSCC, sep = '|'))) != 2) {
        filePathZip <- "downloaded_dataset.zip"
        # Download ziped file
        download.file(rawDataFileUrl, destfile = filePathZip)
        # Unzip
        unzip(filePathZip)
        # Delete downloaded zip file
        file.remove(filePathZip)
}

## Output:
# PNG file
filePathPlotPNG <- "plot5.png"

## Pre-Processing:
# Read Data
NEI <- readRDS(filePathNEI)
SCC <- readRDS(filePathSCC)

# Coal combustion-related sources
coalSector <- unique(grep("vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
coalSCC <- SCC %>%
        filter(EI.Sector %in% coalSector)

totalEmission <- NEI %>%
        # Coal combustion-related sources
        filter(SCC %in% coalSCC$SCC &
        # Baltimore City, Maryland (fips == "24510")
                fips == "24510") %>%
        select(year, Emissions) %>%
        group_by(year) %>%
        summarise_all(sum)

# Characterize to fit ggplot function
totalEmission$year <- as.character(totalEmission$year)

## Plot:
# Device ready
png(filePathPlotPNG)

# Plot
p <- ggplot(data = totalEmission, aes(x = year, y = Emissions)) +
        geom_bar(stat = "identity", position = position_dodge(), fill = "orangered") +
        ggtitle("Motor vehicle sources PM2.5 emission from 1999–2008 in Baltimore City")
print(p)

# Device off
dev.off()

# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#    Using the base plotting system, make a plot showing the total PM2.5 emission from
#    all sources for each of the years 1999, 2002, 2005, and 2008.

library(dplyr)

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
filePathPlotPNG <- "plot1.png"

## Pre-Processing:
# Read Data
NEI <- readRDS(filePathNEI)
SCC <- readRDS(filePathSCC)

totalEmission <- NEI %>%
        select(year, Emissions) %>%
        group_by(year) %>%
        summarise_all(sum)

# Vectorize to fit barplot function
totalEmissionVec <- as.vector(totalEmission$Emissions)
names(totalEmissionVec) <- totalEmission$year

## Plot:
# Device ready
png(filePathPlotPNG)

# Plot
barplot(totalEmissionVec,
     main = "Total PM2.5 Emission",
     xlab = "year",
     ylab = "PM2.5 emission (tons)",
     col = "lightblue")

# Device off
dev.off()

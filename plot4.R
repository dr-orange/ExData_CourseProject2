# 4. Across the United States, how have emissions from coal combustion-related
#    sources changed from 1999–2008?

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
filePathPlotPNG <- "plot4.png"

## Pre-Processing:
# Read Data
NEI <- readRDS(filePathNEI)
SCC <- readRDS(filePathSCC)

# Coal combustion-related sources
coalSector <- unique(grep("coal", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
coalSCC <- SCC %>%
        filter(EI.Sector %in% coalSector)

totalEmission <- NEI %>%
        # Coal combustion-related sources
        filter(SCC %in% coalSCC$SCC) %>%
        select(year, type, Emissions) %>%
        group_by(year, type) %>%
        summarise_all(sum)

# Characterize to fit ggplot function
totalEmission$year <- as.character(totalEmission$year)

## Plot:
# Device ready
png(filePathPlotPNG)

# Plot
p <- ggplot(data = totalEmission, aes(x = year, y = Emissions, fill = type)) +
        geom_bar(stat = "identity", position = position_dodge()) +
        ggtitle("Coal combustion-related sources PM2.5 emission from 1999–2008")
print(p)

# Device off
dev.off()

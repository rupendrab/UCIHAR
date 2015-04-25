library(dplyr)
library(reshape2)

## Modify the datasetDir variable to indicate the directory where the HAR dataset is downloaded 
## or
## Set the working directory to where the downloaded and unzipped directory "UCI HAR Dataset" is located
## before running the script

datasetDir = "./UCI HAR Dataset/"

# Utility function to capitalize the first letter of words

initcap <- function(x) {
        s <- strsplit(x, " ")[[1]]
        paste(toupper(substring(s, 1,1)), substring(s, 2),
              sep="", collapse=" ")
}

# Function to load the features file as a data frame

loadHARFeatures <- function (
        datasetDir,
        featureNamesFile = "features.txt"
        
) {
        featureNamesFile <- paste(datasetDir, featureNamesFile, sep="")
        if (file.exists(featureNamesFile))
        {
                read.table(featureNamesFile)
        }
}

# Function to load activity labels from the activity_labels file as a data frame

loadHARActivityLabels <- function (
        datasetDir,
        activityLabelsFile = "activity_labels.txt"
) {
        activityLabelsFile <- paste(datasetDir, activityLabelsFile, sep="")
        if (file.exists(activityLabelsFile))
        {
                activityLabels <- read.table(activityLabelsFile, stringsAsFactors = FALSE)
                colnames(activityLabels) <- c("id", "name")
                activityLabels
        }
}

# Function to transform the name of the inertialColumns to the standard form source dot average type (dot axis if present)

transformIntertialColumns <- function(columnNames) {
        splitList <- strsplit(gsub("^(.*)_(.*)_([xyz])-(mean|std)\\(\\)", "\\1%\\2%\\3%\\4", columnNames, perl=TRUE),"%")
        sapply(splitList, function(x) {paste("i", initcap(x[1]), initcap(x[2]), ".", x[4], ".", initcap(x[3]), sep="")})
}

# Load a file from the Inertial data set directory. Each of the 128 observations per line are transformed to their mean and standard deviations

loadIntertialFile <- function(fileName, datasetType) {
        if (file.exists(fileName))
        {
                baseName <- basename(fileName)
                dataType <- gsub("^(.*)\\.[^.]*$", "\\1", baseName)
                dataType <- gsub(paste("_",datasetType, sep=""), "", dataType)
                inertialData <- read.table(fileName)
                meanCol <- paste(dataType, "-mean()", sep="")
                stdCol <- paste(dataType, "-std()", sep="")
                inertialData <- as.data.frame(t(apply(inertialData, 1, function(x) c(meanCol=mean(x), stdCol=sd(x)))))
                colnames(inertialData) <- transformIntertialColumns(c(meanCol, stdCol))
                colSource <- data.frame(colnames(inertialData), baseName)
                list("idata" = inertialData, "icolsource" = colSource)
        }
}

# Load all intertial files from a directory into a single data frame (usinf cbind)

loadInertialFiles <- function(
        datasetDir, 
        subdir # Sub directory like test or train 
        ) {
        dirName <- paste(datasetDir, subdir, "/", "Inertial Signals/", sep="")

        if (file.exists(dirName))
        {
                inertialFiles <- dir(dirName, full.names=TRUE)
                i <- 0
                for (inertialFile in inertialFiles) {
                        inertialResult <- loadIntertialFile(inertialFile, datasetType=subdir)
                        inertialData <- inertialResult$idata
                        colSource <- inertialResult$icolsource
                        if (i==0) {
                                inertialDataMain <- inertialData
                                colSourceMain <- colSource
                        }
                        else
                        {
                                inertialDataMain <- cbind(inertialDataMain, inertialData)
                                colSourceMain <- rbind(colSourceMain, colSource)
                        }
                        i <- i + 1
                }
                list("idatamain" = inertialDataMain, "icolsourcemain" = colSourceMain)
        }
}

# Load the entire HAR dataset given the dataset directory, the sub directory (test, train or other), the data file name (defaults 
# to X_<subset name>.txt, the activity file name (defaults to y_<subset name>.txt) and the subject file name (defaults to 
# subject_<subset name>.txt, the features vector and the activity labels data frame

loadHARData <- function(
        datasetDir, 
        subdir, # Sub directory like test or train 
        subfile = paste("X_", subdir, ".txt", sep=""),
        activityfile = paste("y_", subdir, ".txt", sep=""),
        subjectfile = paste("subject_", subdir, ".txt", sep=""),
        featureNames, 
        activityLabels
        ) {
        dataFile <- paste(datasetDir, subdir, "/", subfile, sep="")
        if (file.exists(dataFile)) {
                harData <- read.table(dataFile)
                colnames(harData) <- featureNames[,2]
                importantColumns <- colnames(harData)[grep("mean.*\\(\\)|std\\(\\)", colnames(harData))]
                harDataNew <- harData[,importantColumns]
                rm(harData)
                harDataNew <- cbind("sampleset" = c(subdir), harDataNew)
                
                activityFileName <- paste(datasetDir, subdir, "/", activityfile, sep="")
                if (file.exists(activityFileName)) 
                {
                        activity <- read.table(activityFileName, stringsAsFactors = FALSE)
                        activity[,1] <- factor(activity[,1], levels = activityLabels[,"id"], labels = activityLabels[,"name"])
                        names(activity) <- c("activity.name")
                        harDataNew <- cbind("activity.name" = activity[,1], harDataNew)
                }

                subjectFileName <- paste(datasetDir, subdir, "/", subjectfile, sep="")
                if (file.exists(subjectFileName)) 
                {
                        subject <- read.table(subjectFileName)
                        subject[,1] <- factor(subject[,1], levels= 1:30)
                        harDataNew <- cbind("subject" = subject[,1], harDataNew)
                }
                inertialResult <- loadInertialFiles(datasetDir, subdir)
                inertialData <- inertialResult$idatamain
                if (nrow(inertialData) > 0) {
                        harDataNew = cbind(harDataNew, inertialData)
                }
                list("hardata" = harDataNew, "iColSource" = inertialResult$icolsourcemain)
        }
}

## Function to view the tidy data-set easily by applying a wild-card subset of the measures and also specifying
## whether you want to view the data in the wide form (applyMelt = FALSE) or long form(applyMelt = TRUE). The summaryData
## input is the reference to the data frame containing the tody data set

viewData <- function(summaryData, observation, applyMelt=TRUE) {
        obs <- paste("^", observation, ".*$", sep="")
        measureColumnPositions <- grep(obs, colnames(summaryData))
        measureColumns <- colnames(summaryData)[measureColumnPositions]
        subsetData <- summaryData[,c(1:2,measureColumnPositions)]
        if (applyMelt) {
                subsetData <- melt(data=subsetData, id.vars = c("subject","activity.name"), measure.vars = measureColumns)
        }
        subsetData
}

## Main code to run the entire analysis that loads the raw data and creates the tidy data set and saves it to a file 
## names summaryData.txt in the current working directory
## The script will not run if it is unable to locate the directory specified by the datasetdir set at the beginning of the
## code file

if (file.exists(datasetDir)) {
        featureNames <- loadHARFeatures(datasetDir)
        activityLabels <- loadHARActivityLabels(datasetDir)
        test <- loadHARData(datasetDir, subdir="test", featureNames = featureNames, activityLabels = activityLabels)
        train <- loadHARData(datasetDir, subdir="train", featureNames = featureNames, activityLabels = activityLabels)
        
        allData <- rbind(test$hardata,train$hardata)
        allInertialColumnSource <- test$iColSource
        rm(list=c("test","train"))
        
        oldColumnNames <- colnames(allData)
        colnames(allData) <- gsub("\\(\\)", "", colnames(allData))
        colnames(allData) <- gsub("\\-", ".", colnames(allData))
        
        dim(allData)
        colnames(allData)[-1:-3]
        
        mean_ignore_na <- function(x,...) {
                mean(x, na.rm=TRUE, ...)
        }
        
        summaryData <- summarise_each(group_by(allData, subject, activity.name), funs(mean_ignore_na), -1:-3)
        summaryData <- as.data.frame(summaryData)
        colnames(summaryData) <- gsub("mean_ignore_na$", "average", colnames(summaryData))
        
        # Some debugging code left there just in case
        # dim(summaryData)
        # colnames(summaryData)
        # View(summaryData)
        
        # write.table(allData, file = "allData.txt", row.names=FALSE)
        write.table(summaryData, file = "summaryData.txt", row.names=FALSE)
        sr <- read.table("summaryData.txt", header = TRUE, check.names = FALSE)
} else {
        print(paste("Directory ", datasetDir, " is not found. Plese setwd to the directory where you downloaded and unzipped the data."))
}


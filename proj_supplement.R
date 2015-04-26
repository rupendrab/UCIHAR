library(stringr)

analColumnMain <- function(colName) {
        m <- gregexpr("[A-Z][a-z]+", colName)
        unique(regmatches(colName, m)[[1]])
}

showColumnMain <- function(df) {
        x <- lapply(colnames(df), analColumnMain)
        unique(unlist(x))
}

getDetail <- function(abbr) {
        if (abbr == "Body") {
                abbr
        } else if (abbr == "Acc") {
                "acceleration from Accelerometer"
        } else if (abbr == "Gravity") {
                abbr
        } else if (abbr == "Jerk") {
                abbr
        } else if (abbr == "Gyro") {
                "angular velocity from Gyroscope"
        } else if (abbr == "Mag") {
                "Magnitude"
        } else if (abbr == "Freq") {
                "Frequency"
        }
        else {
                abbr
        }
}

measureType <- function(ind) {
        if (ind == "t") {
                "Time"
        } else if (ind == "f") { 
                "frequency"
        } else if (ind == "f") {
                "frequency"
        } else if (ind == "i") {
                "Inertial"
        }
}

columnDef <- function(columnName) {
        typ <- measureType(substring(columnName,1,1))
        arr <- str_split(columnName, "\\.")[[1]]
        mainAttributes <- sapply(analColumnMain(arr[1]), getDetail)
        aggType <- arr[2]
        if (aggType == "mean") {
                aggType = "Mean"
        } else if (aggType == "meanFreq") {
                aggType = "Mean Frequency"
        } else if (aggType == "std") {
                aggType = "Standard deviation"
        }
        axis <- arr[3]
        mainAttributesStr <- paste(mainAttributes, collapse = " ")
        mainAttributesStr <- gsub("from ([^ ]+) (.*)$", "from \\1 [\\2]", mainAttributesStr)
        def <- paste(aggType, "of", typ, "measure of", mainAttributesStr, sep=" ")
        if (! is.na(axis)) {
                def <- paste(def, "along", axis, "axis")
        }
        def <- paste(def, ". Averaged over subject and activity.", sep="")
        names(def) <- NULL
        def
}

defSummary <- function(df, print=FALSE) {
        defs <- sapply(colnames(df)[-1:-2], columnDef)
        names <- colnames(df)[-1:-2]
        s <- data.frame("columnName" = names, "Definition" = defs, row.names = NULL, stringsAsFactors = FALSE)
        if (! print) {
             s   
        }
        else
        {
                for (i in 1:nrow(s)) {
                        print(paste("####", s[i,1]), sep = " ", quote=FALSE)
                        typ <- substring(s[i,1],1,1)
                        print("", quote=FALSE)
                        print(paste("###### ", s[i,2], sep = " "), quote=FALSE)
                        print(" - Data Type: Numeric", quote=FALSE)
                        if (typ == "t" || typ == "f" ) {
                                print(" - Data Range: -1 to 1", quote=FALSE)
                        }
                        if (typ == "t") {
                                print(" - Unit: Time duration normalized to span -1 to 1", quote=FALSE)
                                print(paste(" - Source: Feature ", oldColumnNames[match(s[i,1], colnames(allData))], sep=""), quote=FALSE)
                        } else if (typ == "f") {
                                print(" - Unit: Frequency, no units, normalized to span -1 to 1", quote=FALSE)
                                print(paste(" - Source: Feature ", oldColumnNames[match(s[i,1], colnames(allData))], sep=""), quote=FALSE)
                        } else if (typ == "i") {
                                if (length(grep("Acc", s[i,1])) > 0) {
                                        print(" - Unit: Standard gravity units 'g'", quote=FALSE)
                                } else if (length(grep("Gyro", s[i,1])) > 0) {
                                        print(" - Unit: Radians per second", quote=FALSE)
                                }
                                aggregateType <- str_split(s[i,1], "\\.")[[1]][2]
                                if (aggregateType == "mean") {
                                        aggregateName = "Calculated Mean"
                                } else if (aggregateType == "std") {
                                        aggregateName = "Calculated Standard deviation"
                                }
                                srcFile <- allInertialColumnSource[(allInertialColumnSource[,1] == s[i,1]),][2][1,1]
                                print(paste(" - Source: ", aggregateName, " of observations in Inertial Data/", srcFile, sep=""), quote=FALSE)
                        }
                        print("", quote=FALSE)
                }
        }
}

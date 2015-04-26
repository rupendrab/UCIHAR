# UCI Human Activity Recognition (HAR) raw data tidying project

## Introduction

This project is created to read the raw data downloaded and unzipped from the [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), combine the data in the various files in the main directory and subdirectories to obtain a tabular data structure, obtain a subset of the measure variables that only has means and standard deviations and then average the observations for each unique subject and activity.

## Modules

1. [CodeBook.md](https://github.com/rupendrab/UCIHAR/blob/master/CodeBook.md) describes the raw data structure, the data cleaning and summarization process and the meaning and source of the variables in the final tidy data set.
2. run_analysis.R is all you need to run the complete analysis
3. proj_supplement.R has been used to generate the variable definitions for CodeBook.md. It would be a very tedious manual process without this code, so I have included this code with the project as well.

## Steps to run the analysis

I have used R version 3.1.2 (Pumpkin Helmet) on a Mac OSX 10.10 (Yosemite) to run the source code. The additional modules needed to run this code are dplyr and reshape2. You must install these packages before you run the analysis. Additionally, the proj_supplement.R code uses the stringr library.

After having the abovementioned modules installed, please execute the following steps:

1. Please place the R source code in some directory.
2. Download the source data. The link is [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). If you do not want to edit the R code at all, you can download it in the same directory where you saved the R code.
3. Unzip the data file.
4. If the directory where you unzipped the data file is different from the the directory where the R source code (run_analysis.R) is located, you can do one of the follwing:
   1. Edit the file run_analysis.R to change the line defining datasetdir at the top of the file to the location where the source data is.
   2. Change working directory to the data directory in R console or R studio using setwd.
5. Run the R file using `source("run_analysis.R")`. Please note that if you changed your directory to a different location than the directory where run_analysis.R is located, you will have to enter the full path in the source command. This will take a couple of minutes as I have added steps to parse through all the Inertial Data files (more description in Code Book).
6. At the end of the process, you will have the following done:
   1. 
   2. 



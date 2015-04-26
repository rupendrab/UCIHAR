# Code Book for the UCI Human Activity Recognition (HAR) raw data tidying project

## The project

We are trying to create a tidy data set needed for further analysis from personal movement activity data collected from a sensor. The input data set can be found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Input Data / Raw Data analysis

Once the data is downloaded and unzipped, it has the following organization:
```
./UCI HAR Dataset/
    README.txt
    activity_labels.txt
    features.txt
    features_info.txt
    test/
        X_test.txt
        subject_test.txt
        y_test.txt
        Inertial Signals/
            body_acc_x_test.txt
            body_acc_y_test.txt
            body_acc_z_test.txt
            body_gyro_x_test.txt
            body_gyro_y_test.txt
            body_gyro_z_test.txt
            total_acc_x_test.txt
            total_acc_y_test.txt
            total_acc_z_test.txt
    train/
        X_train.txt
        subject_train.txt
        y_train.txt
        Inertial Signals/
            body_acc_x_train.txt
            body_acc_y_train.txt
            body_acc_z_train.txt
            body_gyro_x_train.txt
            body_gyro_y_train.txt
            body_gyro_z_train.txt
            total_acc_x_train.txt
            total_acc_y_train.txt
            total_acc_z_train.txt
```

The file activity_labels.txt translatest numeric activity codes to activity names. File features.txt lists all the features available in the primary datasets.
There are two datasets available with similar data test and train, data for each are stored in sub-directories named after them.

1. The file X_*.txt have one line corresponding to one observation of a set of 561 feature variables. The values are separated by whitespace and the corresponding labels can be found in features.txt
2. The file y_*.txt simply shows the activity id (1-6) for each of the observations in 1.
3. The file subject_*.txt shows the person id / subject id (1-30) for each of the observations in 1.
4. There is a sub-directory named Inertial Signals under each data set that has a list of 9 files for raw data collected from the accelerometer and gyroscope. The file name indicates the variable that was observed. The file contains a set of 128 whitespace delimited variables captured for each observation listed in 1.

**This analysis clearly shows that each file described in 1-4 above have the same number of lines and each line refers to the same sample observation of the set of variables.

### Data transformations done by the tidying process

1. Read the features names from features.txt (in a data.frame)
2. Read the activity labels (code and description) from activity_labels.txt (in a data.frame)
3. For each of the test and train datasets, obtain the raw data in a tabular form like below:
   1. Read X_*.txt into a data.frame. Now we have each of the 561 variables captured in a column
   2. Name the columns using the feature names dataset
   3. Read the activity labels from y_*.txt and factorize them to their descriptions using the activity labels dataset
   4. Read the subject ids from the subject_*.txt and factorize them
   5. Add subject and activity name to the main dataset in step 2 using cbind
   6. Filter out only the columns that have the characters "mean()", "meanFreq()" or "std()" in them as we are only interested in the mean and standard deviation data.
   7. We are also curious about the Inertial data set. However, this data is slightly more complex as it has multiple (128 to be exact) values recorded per observation and also has one file per variable. To handle this, we do the following:
   8. For each file in the "Inertial Data" subdirectory:
      1. Read the data into a data.frame. This is a n row 128 column data frame.
      2. Create a n row 2 column data frame from 1 by calculating row means and row standard deviations for variables in each row.
      3. Name the mean and standard deviation columns such that they reflect the data type in the file name, the aggregation type (mean or std), and the data axis represented in the file name. So, the mean column calculated from 

### The tidy data set

The tidy data set contains a total of 180 records of 99 variables. 
Each record corresponds to the averages of the various measures collected for each of the six activities of the 30 subjects that participated in the experiment.
The first two variables correspond to the subject and the activity name over which the averages are computed.
The other 97 variables comprise of 40 time domain feature variables (start with t), 39 frequency domain feature variabled (start with f) and 18 variables computed from the Inertial data set provided (start with i).

The naming convention of the variables is like below:

Starts with the lowercase letter t, f, i corresponding to the measurement type (t for time, f for frequency and i for inertial)
A descriptive name of the variable until the first .
The type of pre-summarization done on the data element (mean or std) between the after the first dot
If there is a second dot, the last part is X, Y or Z indicating the axis along which the variable was measured

The detailed definition of each of the variables in the data set is below:

#### subject

###### The subject (person identified by a number) that participated in the tests
 - Data Type: Factor
 - Data Values: 1 to 30 (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30)
 - Source: subject_[*Data Set*].txt (e.g. subject_test.txt and subject_train.txt if the datasets are test and train)

#### activity.name

###### The activity performed by the subject while the various observation variables were recorded
 - Data Type: Factor
 - Data Values: <br/>
     &nbsp;&nbsp;WALKING<br/>
     &nbsp;&nbsp;WALKING_UPSTAIRS<br/>
     &nbsp;&nbsp;WALKING_DOWNSTAIRS<br/>
     &nbsp;&nbsp;SITTING<br/>
     &nbsp;&nbsp;STANDING<br/>
     &nbsp;&nbsp;LAYING<br/>
 - Source: activity_labels.txt

#### tBodyAcc.mean.X

######  Mean of Time measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-X

#### tBodyAcc.mean.Y

######  Mean of Time measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-Y

#### tBodyAcc.mean.Z

######  Mean of Time measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-Z

#### tBodyAcc.std.X

######  Standard deviation of Time measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-X

#### tBodyAcc.std.Y

######  Standard deviation of Time measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-Y

#### tBodyAcc.std.Z

######  Standard deviation of Time measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-Z

#### tGravityAcc.mean.X

######  Mean of Time measure of Gravity acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-X

#### tGravityAcc.mean.Y

######  Mean of Time measure of Gravity acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-Y

#### tGravityAcc.mean.Z

######  Mean of Time measure of Gravity acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-Z

#### tGravityAcc.std.X

######  Standard deviation of Time measure of Gravity acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-X

#### tGravityAcc.std.Y

######  Standard deviation of Time measure of Gravity acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-Y

#### tGravityAcc.std.Z

######  Standard deviation of Time measure of Gravity acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-Z

#### tBodyAccJerk.mean.X

######  Mean of Time measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-X

#### tBodyAccJerk.mean.Y

######  Mean of Time measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-Y

#### tBodyAccJerk.mean.Z

######  Mean of Time measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-Z

#### tBodyAccJerk.std.X

######  Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-X

#### tBodyAccJerk.std.Y

######  Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-Y

#### tBodyAccJerk.std.Z

######  Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-Z

#### tBodyGyro.mean.X

######  Mean of Time measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-X

#### tBodyGyro.mean.Y

######  Mean of Time measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-Y

#### tBodyGyro.mean.Z

######  Mean of Time measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-Z

#### tBodyGyro.std.X

######  Standard deviation of Time measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-X

#### tBodyGyro.std.Y

######  Standard deviation of Time measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-Y

#### tBodyGyro.std.Z

######  Standard deviation of Time measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-Z

#### tBodyGyroJerk.mean.X

######  Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-X

#### tBodyGyroJerk.mean.Y

######  Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-Y

#### tBodyGyroJerk.mean.Z

######  Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-Z

#### tBodyGyroJerk.std.X

######  Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-X

#### tBodyGyroJerk.std.Y

######  Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-Y

#### tBodyGyroJerk.std.Z

######  Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-Z

#### tBodyAccMag.mean

######  Mean of Time measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccMag-mean()

#### tBodyAccMag.std

######  Standard deviation of Time measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccMag-std()

#### tGravityAccMag.mean

######  Mean of Time measure of Gravity acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAccMag-mean()

#### tGravityAccMag.std

######  Standard deviation of Time measure of Gravity acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAccMag-std()

#### tBodyAccJerkMag.mean

######  Mean of Time measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerkMag-mean()

#### tBodyAccJerkMag.std

######  Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerkMag-std()

#### tBodyGyroMag.mean

######  Mean of Time measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroMag-mean()

#### tBodyGyroMag.std

######  Standard deviation of Time measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroMag-std()

#### tBodyGyroJerkMag.mean

######  Mean of Time measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerkMag-mean()

#### tBodyGyroJerkMag.std

######  Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerkMag-std()

#### fBodyAcc.mean.X

######  Mean of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-X

#### fBodyAcc.mean.Y

######  Mean of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-Y

#### fBodyAcc.mean.Z

######  Mean of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-Z

#### fBodyAcc.std.X

######  Standard deviation of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-X

#### fBodyAcc.std.Y

######  Standard deviation of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-Y

#### fBodyAcc.std.Z

######  Standard deviation of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-Z

#### fBodyAcc.meanFreq.X

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-X

#### fBodyAcc.meanFreq.Y

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-Y

#### fBodyAcc.meanFreq.Z

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-Z

#### fBodyAccJerk.mean.X

######  Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-X

#### fBodyAccJerk.mean.Y

######  Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-Y

#### fBodyAccJerk.mean.Z

######  Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-Z

#### fBodyAccJerk.std.X

######  Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-X

#### fBodyAccJerk.std.Y

######  Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-Y

#### fBodyAccJerk.std.Z

######  Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-Z

#### fBodyAccJerk.meanFreq.X

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-X

#### fBodyAccJerk.meanFreq.Y

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-Y

#### fBodyAccJerk.meanFreq.Z

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-Z

#### fBodyGyro.mean.X

######  Mean of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-X

#### fBodyGyro.mean.Y

######  Mean of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-Y

#### fBodyGyro.mean.Z

######  Mean of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-Z

#### fBodyGyro.std.X

######  Standard deviation of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-X

#### fBodyGyro.std.Y

######  Standard deviation of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-Y

#### fBodyGyro.std.Z

######  Standard deviation of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-Z

#### fBodyGyro.meanFreq.X

######  Mean Frequency of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-X

#### fBodyGyro.meanFreq.Y

######  Mean Frequency of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-Y

#### fBodyGyro.meanFreq.Z

######  Mean Frequency of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-Z

#### fBodyAccMag.mean

######  Mean of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-mean()

#### fBodyAccMag.std

######  Standard deviation of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-std()

#### fBodyAccMag.meanFreq

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-meanFreq()

#### fBodyBodyAccJerkMag.mean

######  Mean of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-mean()

#### fBodyBodyAccJerkMag.std

######  Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-std()

#### fBodyBodyAccJerkMag.meanFreq

######  Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-meanFreq()

#### fBodyBodyGyroMag.mean

######  Mean of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-mean()

#### fBodyBodyGyroMag.std

######  Standard deviation of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-std()

#### fBodyBodyGyroMag.meanFreq

######  Mean Frequency of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-meanFreq()

#### fBodyBodyGyroJerkMag.mean

######  Mean of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-mean()

#### fBodyBodyGyroJerkMag.std

######  Standard deviation of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-std()

#### fBodyBodyGyroJerkMag.meanFreq

######  Mean Frequency of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.
 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-meanFreq()

#### iBodyAcc.mean.X

######  Mean of Inertial measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_x_test.txt

#### iBodyAcc.std.X

######  Standard deviation of Inertial measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_x_test.txt

#### iBodyAcc.mean.Y

######  Mean of Inertial measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_y_test.txt

#### iBodyAcc.std.Y

######  Standard deviation of Inertial measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_y_test.txt

#### iBodyAcc.mean.Z

######  Mean of Inertial measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_z_test.txt

#### iBodyAcc.std.Z

######  Standard deviation of Inertial measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_z_test.txt

#### iBodyGyro.mean.X

######  Mean of Inertial measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_x_test.txt

#### iBodyGyro.std.X

######  Standard deviation of Inertial measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_x_test.txt

#### iBodyGyro.mean.Y

######  Mean of Inertial measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_y_test.txt

#### iBodyGyro.std.Y

######  Standard deviation of Inertial measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_y_test.txt

#### iBodyGyro.mean.Z

######  Mean of Inertial measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_z_test.txt

#### iBodyGyro.std.Z

######  Standard deviation of Inertial measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_z_test.txt

#### iTotalAcc.mean.X

######  Mean of Inertial measure of Total acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_x_test.txt

#### iTotalAcc.std.X

######  Standard deviation of Inertial measure of Total acceleration from Accelerometer along X axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_x_test.txt

#### iTotalAcc.mean.Y

######  Mean of Inertial measure of Total acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_y_test.txt

#### iTotalAcc.std.Y

######  Standard deviation of Inertial measure of Total acceleration from Accelerometer along Y axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_y_test.txt

#### iTotalAcc.mean.Z

######  Mean of Inertial measure of Total acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_z_test.txt

#### iTotalAcc.std.Z

######  Standard deviation of Inertial measure of Total acceleration from Accelerometer along Z axis. Averaged over subject and activity.
 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_z_test.txt


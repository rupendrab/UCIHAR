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

### tBodyAcc.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-X
 - Description: Mean of Time measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### tBodyAcc.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-Y
 - Description: Mean of Time measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### tBodyAcc.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-mean()-Z
 - Description: Mean of Time measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### tBodyAcc.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-X
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### tBodyAcc.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-Y
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### tBodyAcc.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAcc-std()-Z
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### tGravityAcc.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-X
 - Description: Mean of Time measure of Gravity acceleration from Accelerometer along X axis. Averaged over subject and activity.

### tGravityAcc.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-Y
 - Description: Mean of Time measure of Gravity acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### tGravityAcc.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-mean()-Z
 - Description: Mean of Time measure of Gravity acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### tGravityAcc.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-X
 - Description: Standard deviation of Time measure of Gravity acceleration from Accelerometer along X axis. Averaged over subject and activity.

### tGravityAcc.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-Y
 - Description: Standard deviation of Time measure of Gravity acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### tGravityAcc.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAcc-std()-Z
 - Description: Standard deviation of Time measure of Gravity acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### tBodyAccJerk.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-X
 - Description: Mean of Time measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.

### tBodyAccJerk.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-Y
 - Description: Mean of Time measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.

### tBodyAccJerk.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-mean()-Z
 - Description: Mean of Time measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.

### tBodyAccJerk.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-X
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.

### tBodyAccJerk.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-Y
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.

### tBodyAccJerk.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerk-std()-Z
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.

### tBodyGyro.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-X
 - Description: Mean of Time measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### tBodyGyro.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-Y
 - Description: Mean of Time measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### tBodyGyro.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-mean()-Z
 - Description: Mean of Time measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### tBodyGyro.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-X
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### tBodyGyro.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-Y
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### tBodyGyro.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyro-std()-Z
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### tBodyGyroJerk.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-X
 - Description: Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along X axis. Averaged over subject and activity.

### tBodyGyroJerk.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-Y
 - Description: Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along Y axis. Averaged over subject and activity.

### tBodyGyroJerk.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-mean()-Z
 - Description: Mean of Time measure of Body angular velocity from Gyroscope [Jerk] along Z axis. Averaged over subject and activity.

### tBodyGyroJerk.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-X
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along X axis. Averaged over subject and activity.

### tBodyGyroJerk.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-Y
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along Y axis. Averaged over subject and activity.

### tBodyGyroJerk.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerk-std()-Z
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk] along Z axis. Averaged over subject and activity.

### tBodyAccMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccMag-mean()
 - Description: Mean of Time measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### tBodyAccMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccMag-std()
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### tGravityAccMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAccMag-mean()
 - Description: Mean of Time measure of Gravity acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### tGravityAccMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tGravityAccMag-std()
 - Description: Standard deviation of Time measure of Gravity acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### tBodyAccJerkMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerkMag-mean()
 - Description: Mean of Time measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.

### tBodyAccJerkMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyAccJerkMag-std()
 - Description: Standard deviation of Time measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.

### tBodyGyroMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroMag-mean()
 - Description: Mean of Time measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.

### tBodyGyroMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroMag-std()
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.

### tBodyGyroJerkMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerkMag-mean()
 - Description: Mean of Time measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.

### tBodyGyroJerkMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Time duration normalized to span -1 to 1
 - Source: Feature tBodyGyroJerkMag-std()
 - Description: Standard deviation of Time measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.

### fBodyAcc.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-X
 - Description: Mean of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### fBodyAcc.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-Y
 - Description: Mean of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### fBodyAcc.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-mean()-Z
 - Description: Mean of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### fBodyAcc.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-X
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### fBodyAcc.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-Y
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### fBodyAcc.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-std()-Z
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### fBodyAcc.meanFreq.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-X
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### fBodyAcc.meanFreq.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-Y
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### fBodyAcc.meanFreq.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAcc-meanFreq()-Z
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### fBodyAccJerk.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-X
 - Description: Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.

### fBodyAccJerk.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-Y
 - Description: Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.

### fBodyAccJerk.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-mean()-Z
 - Description: Mean of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.

### fBodyAccJerk.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-X
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.

### fBodyAccJerk.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-Y
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.

### fBodyAccJerk.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-std()-Z
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.

### fBodyAccJerk.meanFreq.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-X
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along X axis. Averaged over subject and activity.

### fBodyAccJerk.meanFreq.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-Y
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along Y axis. Averaged over subject and activity.

### fBodyAccJerk.meanFreq.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccJerk-meanFreq()-Z
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk] along Z axis. Averaged over subject and activity.

### fBodyGyro.mean.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-X
 - Description: Mean of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### fBodyGyro.mean.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-Y
 - Description: Mean of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### fBodyGyro.mean.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-mean()-Z
 - Description: Mean of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### fBodyGyro.std.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-X
 - Description: Standard deviation of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### fBodyGyro.std.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-Y
 - Description: Standard deviation of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### fBodyGyro.std.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-std()-Z
 - Description: Standard deviation of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### fBodyGyro.meanFreq.X

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-X
 - Description: Mean Frequency of frequency measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### fBodyGyro.meanFreq.Y

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-Y
 - Description: Mean Frequency of frequency measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### fBodyGyro.meanFreq.Z

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyGyro-meanFreq()-Z
 - Description: Mean Frequency of frequency measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### fBodyAccMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-mean()
 - Description: Mean of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### fBodyAccMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-std()
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### fBodyAccMag.meanFreq

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyAccMag-meanFreq()
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer [Magnitude]. Averaged over subject and activity.

### fBodyBodyAccJerkMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-mean()
 - Description: Mean of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.

### fBodyBodyAccJerkMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-std()
 - Description: Standard deviation of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.

### fBodyBodyAccJerkMag.meanFreq

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyAccJerkMag-meanFreq()
 - Description: Mean Frequency of frequency measure of Body acceleration from Accelerometer [Jerk Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-mean()
 - Description: Mean of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-std()
 - Description: Standard deviation of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroMag.meanFreq

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroMag-meanFreq()
 - Description: Mean Frequency of frequency measure of Body angular velocity from Gyroscope [Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroJerkMag.mean

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-mean()
 - Description: Mean of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroJerkMag.std

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-std()
 - Description: Standard deviation of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.

### fBodyBodyGyroJerkMag.meanFreq

 - Data Type: Numeric
 - Data Range: -1 to 1
 - Unit: Frequency, no units, normalized to span -1 to 1
 - Source: Feature fBodyBodyGyroJerkMag-meanFreq()
 - Description: Mean Frequency of frequency measure of Body angular velocity from Gyroscope [Jerk Magnitude]. Averaged over subject and activity.

### iBodyAcc.mean.X

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_x_test.txt
 - Description: Mean of Inertial measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### iBodyAcc.std.X

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_x_test.txt
 - Description: Standard deviation of Inertial measure of Body acceleration from Accelerometer along X axis. Averaged over subject and activity.

### iBodyAcc.mean.Y

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_y_test.txt
 - Description: Mean of Inertial measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### iBodyAcc.std.Y

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_y_test.txt
 - Description: Standard deviation of Inertial measure of Body acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### iBodyAcc.mean.Z

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/body_acc_z_test.txt
 - Description: Mean of Inertial measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### iBodyAcc.std.Z

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/body_acc_z_test.txt
 - Description: Standard deviation of Inertial measure of Body acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### iBodyGyro.mean.X

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_x_test.txt
 - Description: Mean of Inertial measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### iBodyGyro.std.X

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_x_test.txt
 - Description: Standard deviation of Inertial measure of Body angular velocity from Gyroscope along X axis. Averaged over subject and activity.

### iBodyGyro.mean.Y

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_y_test.txt
 - Description: Mean of Inertial measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### iBodyGyro.std.Y

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_y_test.txt
 - Description: Standard deviation of Inertial measure of Body angular velocity from Gyroscope along Y axis. Averaged over subject and activity.

### iBodyGyro.mean.Z

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Mean of observations in Inertial Data/body_gyro_z_test.txt
 - Description: Mean of Inertial measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### iBodyGyro.std.Z

 - Data Type: Numeric
 - Unit: Radians per second
 - Source: Calculated Standard deviation of observations in Inertial Data/body_gyro_z_test.txt
 - Description: Standard deviation of Inertial measure of Body angular velocity from Gyroscope along Z axis. Averaged over subject and activity.

### iTotalAcc.mean.X

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_x_test.txt
 - Description: Mean of Inertial measure of Total acceleration from Accelerometer along X axis. Averaged over subject and activity.

### iTotalAcc.std.X

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_x_test.txt
 - Description: Standard deviation of Inertial measure of Total acceleration from Accelerometer along X axis. Averaged over subject and activity.

### iTotalAcc.mean.Y

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_y_test.txt
 - Description: Mean of Inertial measure of Total acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### iTotalAcc.std.Y

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_y_test.txt
 - Description: Standard deviation of Inertial measure of Total acceleration from Accelerometer along Y axis. Averaged over subject and activity.

### iTotalAcc.mean.Z

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Mean of observations in Inertial Data/total_acc_z_test.txt
 - Description: Mean of Inertial measure of Total acceleration from Accelerometer along Z axis. Averaged over subject and activity.

### iTotalAcc.std.Z

 - Data Type: Numeric
 - Unit: Standard gravity units 'g'
 - Source: Calculated Standard deviation of observations in Inertial Data/total_acc_z_test.txt
 - Description: Standard deviation of Inertial measure of Total acceleration from Accelerometer along Z axis. Averaged over subject and activity.



Codebook
========

Getting and Cleaning Data Assignment using the Human Activity Recognition Using Smartphones Dataset.

This Codebook describes the source data, and the transformations performed on that data.

###The Assignment  instructions


Submit a run_analysis script that does the following:

1.Merges the training and the test sets to create one data set.

2.Extracts only the measurements on the mean and standard deviation for each measurement.

3.Uses descriptive activity names to name the activities in the data set

4.Appropriately labels the data set with descriptive variable names.

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


###About the source variables

The source  data, original README, and Codebook can be downloaded here:
[UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

###Experimental details
Thirty volunteers(aged 19-48 years.) wore a Samsung Galaxy S II smartphone strapped to their waist whilst performing six different activities. Using the built in accelerometer and gyroscope  3-axial raw signals tAcc-XYZ and tGyro-XYZ were recorded.   

###Summarising the raw variables as described in the UCI Codebook 
Raw data:

     tAcc-XYZ                 Acc=Accelorometer, units=standard gravity units 'g'
     tGyro-XYZ                Gyro=Gyroscope, units=radians/second
                              -XYZ= one of  3 directions(-X, -Y or -Z) eg tACC-Y
                              prefix t=time 

Processed data:
seperated into: 

     tBodyAcc-XYZ            Body=acceleration due to body
     tGravityAcc-XYZ         Acc=acceleration due to gravity 
 
seperated into:

     tBodyAccJerk-XYZ       Body linear Acceleration
     tBodyGyroJerk-XYZ.     Body Angular Velocity
    
magnitude calculated:

     tBodyAccMag             Mag=Magnitude
     tBodyAccMag
     tGravityAccMag
     tBodyAccJerkMag
     tBodyGyroMag
     tBodyGyroJerkMag
     
fast fourier transform (FFT)  applied to some of the above
    
     fBodyAcc-XYZ           prefix f=frequency
     fBodyAccJerk-XYZ
     fBodyGyro-XYZ
     fBodyAccMag
     fBodyAccJerkMag 
     fBodyGyroMag
     fBodyGyroJerkMag
     
Various summary statistics obtained including  means, std ,max, min, kurtosis...

for example-
     tBodyAccJerk-std()-X
     tBodyAccJerk-mean()-X

Additional vectors  obtained by  averaging the signals over a sample window

     gravityMean
     tBodyAccMean
     tBodyAccJerkMean
     tBodyGyroMean
     tBodyGyroJerkMean
     
finally:    
    
    angle(tBodyGyroJerkMean)  angle(): Angle between two vectors


### Rationale for some Tricky decisions 

### (a)Which columns are measurements of mean and standard deviation?

Assignment instructions read"Extracts only the measurements on the mean and standard deviation for each measurement."

My code  selected ALL columns with mean or std (upper or lower case) in their column names, rather than search only for specific means   eg (grepl("mean\\(\\)|std\\(\\)) which  excludes values without brackets following the mean or std , such as mean frequency. Whilst there are solid arguments for excluding some mean values- , I decided  to play safe, including all "means" -not being a physicist it's hard for me to judge how meaningful the mean of a frequency window is & after all , all  the measurements are different approacches to taking the means of a "measurement".

require(dplyr)

    tidy_data<-select(mergeddat,contains("id"), contains("activity"),contains("mean"),contains("std")

For more discussion on what columns to extract, see
[getting and cleaning assignment](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

###(b) What do "BodyBody" column names represent?

Features.txt contains 39 variables with a double " BodyBody" string!

    body<-select(mergeddat,contains("BodyBody"))
    head(colnames(body))
    
   [1] "fBodyBodyAccJerkMag.mean.."*  "fBodyBodyAccJerkMag.std.."  "fBodyBodyAccJerkMag.mad.."                         "fBodyBodyAccJerkMag.max.." 
   [5]"fBodyBodyAccJerkMag.min.."  "fBodyBodyAcc

However:

(1)"BodyBody" strings  are not listed in  the UCI HAR documentation, let alone defined! 

(2) if there is a "BodyBody" variable, the corresponding "Body" variable is missing

for example   the  columnames listed above beginning "fBodyBodyAccJerkMag..."  exist in the source data colummn names features.txt ,but not in the UCI Codebook. The corresponding "fBodyAccJerkMag.x" values do not exist in the data  , but  in the Codebook .
 
To test if this applied to all "BodyBody" Variables-

.I first changed "BodyBody" strings in column names  to "Body":

    bodytest<-gsub("BodyBody","Body",colnames(mean_data))
     
Then  checked to see if  this produced  any duplicated colnames , which would happen if "BodyBody" and "Body" are
different variables:

    which(duplicated(colnames(bodytest)))
    Ans:integer(0)

Since no duplicated column names are produced : I  assumed that "BodyBody names result from an accidental corruption of some "Body"" column names. I tidied all "BodyBody" strings to "Body" in the final mean data set. 

###tidy-data variables 

activity: levels: 	"walking", "walking-upstairs","walking_downstairs"","standing","sitting","laying"

subjectid :	identifier  for  each subject

std(): Standard deviation of multiple measurements from the source data.

mean() mean of multiple measurements from the source data.

DataGran 2016-02-23

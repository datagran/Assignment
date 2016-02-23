#  to run set your working directory to the file containing the UCI dataset

require(dplyr) 
require(reshape2)

# read in the files
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "activity"),quote="\"",comment.char="") 

features <- read.table("UCI HAR Dataset/features.txt", col.names=c("id", "name"),  quote="\"", comment.char="")
#load test data
xtest <- read.table("UCI HAR Dataset/test/X_test.txt",col.names=features$name, quote="\"", comment.char="")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt",col.names= "activity", quote="\"", comment.char="")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt",  col.names= "subjectid", quote="\"", comment.char="")
#load training data
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names= "subjectid", quote="\"", comment.char="")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$name,quote="\"", comment.char="")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt",col.names= "activity", quote="\"", comment.char="")
#other 
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("id", "activity"),quote="\"", comment.char="")
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("id", "name"), quote="\"", comment.char="")


#Uses descriptive activity names to name the activities in the data set
actlev<-activitylabels[,2]
## modifying activity names
## lower case-easier to read than capitals
actclean<-tolower(actlev)


#change activity labels to factor
label<-actclean
ytest[,1]<-as.numeric(ytest[,1])
ytest[,1]<-factor(ytest[,1])
levels( ytest[,1]) <- c(label)
ytrain[,1]<-as.numeric(ytrain[,1])
ytrain[,1]<-factor(ytrain[,1])

levels(ytrain[,1]) <- c(label)


# creates aggregated  training and  test data sets  and merGES esto create one data set.
#Appropriately labels the data set with descriptive variable names 
testdat<-cbind(subjecttest,ytest,xtest)

traindat<-cbind(subjecttrain,ytrain,xtrain)

mergeddat<-rbind(traindat,testdat)

#Extracts only  the mean and standard deviation for each measurement.
# selects all occurences of 'mean' in the column names- for reasoning see Codebook)
 
tidy_data<-select(mergeddat,contains("id"), contains("activity"),contains("mean"),contains("std"))


# Remove a "Body" from "BodyBody" strings in column names
#  because some variables names appear to have been corrupted with a lengthened "Body" string 
# see codebook for  explanation
colnames(tidy_data) <- gsub("BodyBody","Body", as.character(colnames(tidy_data)))
##check if second "Body" removal has produced duplicate column names
sum(duplicated (colnames(tidy_data)))
#[1] 0 

write.table(tidy_data, "tidy_data.txt",row.names = FALSE)

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.

meltdat <- melt(tidy_data,id=c("activity","subjectid"))
mean_data <- dcast(meltdat, activity  + subjectid ~ variable, mean)
write.table(mean_data, "mean_data.txt",row.names = FALSE)

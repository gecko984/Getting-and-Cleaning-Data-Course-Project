######ATTENTION#####

#Please use setwd() to specify the path to "UCI HAR Dataset" directory on your computer, for example:
#setwd("C:/DSS/UCI HAR Dataset/") 


#ATTENTION: This script uses the dplyr package.
#You can install it by entering install.packages("dplyr") in the R console.


#This is the script for the course project for the Getting and Cleaning Data
#course in the JHU Data Science Specialization on Coursera.

#Created by Fedor Indukaev on 2015.10.24

#The dataset for this script is available at 
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#or
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


##########################

#Loading features list:

features <- read.table("features.txt")


#Loading the train data:

subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")


#Loading the test data:

subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")


#Specifying activity labels from activity_labels.txt manually:

activity_labels <- c("Walking", "Walking upstairs", "Walking downstairs",
                     "Sitting", "Standing", "Laying")


#Merging train and test data into a single dataset:

X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)


#y, subject and features are dataframes each having a single significant
#column.
#Extracting these columns as vectors:

y <- y[,1] 
subject <- subject[,1]
features <-features[,2]


#There is some untidiness in the feature names, specifically some variable names
#have repetitions of "Body", which makes the list unconsistent with info
#provided in the features_info.txt file.
#Cleaning up:

features <- sub("BodyBody","Body", features)


#Removing unnecessary data from the environment to save memory:
rm(list=c("subject_train", "subject_test", "X_train", "X_test", "y_train", "y_test")) 


#Assigning names to variables:
colnames(X) <- features


#The task is to keep just the columns with the mean and standard deviation for 
#each measurement. We will find these columns using the grep() function. The 
#double backslashes are used to make grep() match the brackets. This is done to
#avoid selecting columns like "fBodyGyroJerkMag-meanFreq()", which we do not
#need. value="TRUE" means grep() will return list of matching column names and
#not of their indices.

#Making a list of all mean() columns names:

mean_cols <- grep("mean\\(\\)", features, value=TRUE)


#Making a list of all std() columns name:

std_cols <- grep("std\\(\\)", features, value=TRUE)


#Joining the two lists together:

cols_to_keep <- c(mean_cols, std_cols)


#Dropping all other columns from the dataset:

X <- X[cols_to_keep]


#Replacing labels in the activities vector y by their respective desriptive
#names.

y_descr <- factor(y, labels=activity_labels)


#Adding Subject and Activity labels as two first column of our dataset.

X <- cbind(subject, y_descr, X)


#Assigning names to the two new columns

colnames(X)[1:2] <- c("Subject", "Activity")

#Using group_by() and summarize_each() functions from dplyr to make the data set
#with the average of each variable for each activity and each subject.

X_avgs <- X %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))


#Writing the resulting dataset to file

write.table(X_avgs, file = "X_avgs.txt", row.name=FALSE)

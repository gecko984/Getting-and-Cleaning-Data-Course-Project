# Getting and Cleaning Data course Project

This is the course project for the [JHU Getting and Cleaning Data course on Coursera](https://www.coursera.org/course/getdata).

Created by Fedor Indukaev,
Oct 26 2015

This repo contains the following files

* README.md - this file
* CodeBook.md - the codebook, containing general information on the dataset, 
* run_analysis.R - the script performing the data clearing process.

The data for the script is available at [UC Irvine Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

##How to use the script

1. Download the full dataset [here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip) or [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Unzip the zipped file to your computer.
3. Clone this repository to your computer and open [run_analysis.R script](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/run_analysis.R)  in your R development environment.
4. Set the working directory to your "UCI HAR Dataset" directory created in step 2. For example, `setwd("C:/DSS/UCI HAR Dataset/")` 
5. Make sure `dplyr` package is installed. If not, install it by entering `install.packages("dplyr")` in your R console.
6. Run the script. The tidy dataset `X_avgs` will be created in your environment and a file named `X_avgs.txt` containing it will be created in your working directory. 


##Very short introduction to the dataset

The dataset contains sensor data, derived from signals of accelerometer and gyroscope of a smartphone worn by 30 peoples performing 6 kinds of activities - Walking, Walking upstairs, Walking downstairs, Sitting, Standing and Laying. The creatrs of the dataset strived to create an olgorithm which would identify what physical activity a person is performing based on the data from the gyroscope and accelerometer in the smartphonw this person carried. 

The signals from the two sensors were expanded into 561 different measured variables with the use of different statistics and mathematical functions. For more detail se CodeBook.md and info in the original dataset.

We will need the following files from the dataset:

* `X_train.txt` contains 7352 observations of 561 variables. Each row is a observation of 561 variables (see CodeBook.md in this repo) during one timeframe of 2.56 seconds of one experiment (one subject performing one activity).
* `X_test.txt` contains 2947 observations of 561 variables and is similar to `X_train.txt`
* `features.txt` contains the names of the 561 measured variables
* `subject_train.txt` contain the subject id's corresponding to each observation in `X_train.txt`. It has 7352 rows and 1 column.
*`subject_test.txt` contain the subject id's corresponding to each observation in `X_test.txt`. It has 2947 rows and 1 column.
* `y_train.txt`  contains the activities labels corresponding to each observation in `X_train.txt`. It has 7352 rows and, unlike `subject_train.txt`,  two columns, the first being just the index number, which we will later discard.
* `y_test.txt` has 2947 rows and 2 columns, similar to `y_train.txt`.

##What the script does
The script cleans up and summarizes the data from the original dataset, according to course assignment, giving averages of a specific subset of measured variables for each subject and activity.

##Script step-by step explanation

First, please don't forget to [download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) the dataset, unzip it and set your working directory to the "UCI HAR Dataset" directory on your computer, for example^
```
#setwd("C:/DSS/UCI HAR Dataset/") 
```
THe script works as follows:
First, it loads all neccesary data

* The vector of feature names
```
features <- read.table("features.txt")
```

* The vectors of subject id's for each record in train and test data
```
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
```

* The train and test datasets of measure variables for each record
```
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
```

Then it specifies activity labels from activity_labels.txt manually:
```
activity_labels <- c("Walking", "Walking upstairs", "Walking downstairs",
                     "Sitting", "Standing", "Laying")
```

It then merges train and test data into a single dataset using `rbind()`:
```
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
```

The `read.table()` returns a dataframe, but for `y`, `subject` and `features` what we really need is vectors. The script extracts these columns as vectors. Also, converting subject id's from integer to factor:

```
y <- y[,1] 
subject <- as.factor(subject[,1])
features <-features[,2]
```

There is some untidiness in the feature names, specifically some variable names have repetitions of "Body", which makes the list unconsistent with info provided in the features_info.txt file. Te script cleans that up:
```
features <- sub("BodyBody","Body", features)
```

The script then removes unnecessary data from the environment to save memory:
```
rm(list=c("subject_train", "subject_test", "X_train", "X_test", "y_train", "y_test")) 
```

The next step is to assign the feature names to the features:
```
colnames(X) <- features
```

The assignment is to keep just the columns with the mean and standard deviation for each measurement. The script finds these columns using the grep() function, returning the list of the columns we need. The double backslashes are used to make grep() match the brackets. This is done to avoid selecting columns like "fBodyGyroJerkMag-meanFreq()", which, I belive do net relate to the assignment. 

Making a list of all mean() columns names:
```
mean_cols <- grep("mean\\(\\)", features, value=TRUE)
```

Making a list of all std() columns name:
```
std_cols <- grep("std\\(\\)", features, value=TRUE)
```

Joining the two lists together:
```
cols_to_keep <- c(mean_cols, std_cols)
```

Dropping all other columns from the dataset:
```
X <- X[cols_to_keep]
```

Replacing labels in the activities vector y by their respective desriptive names.
```
y_descr <- factor(y, labels=activity_labels)
```

Adding Subject and Activity labels as two first column of our dataset.
```
X <- cbind(subject, y_descr, X)
```

Assigning names to the two new columns
```
colnames(X)[1:2] <- c("Subject", "Activity")
```
Using group_by() and summarize_each() functions from dplyr to make the data set with the average of each variable for each activity and each subject.
```
X_avgs <- X %>% group_by(Subject, Activity) %>% summarise_each(funs(mean))
```

Writing the resulting dataset to file
```
write.table(X_avgs, file = "X_avgs.txt", row.name=FALSE)
```

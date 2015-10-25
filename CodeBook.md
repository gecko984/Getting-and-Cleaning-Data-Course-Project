---
title: "Getting and Cleaning Data course project"
author: "Fedor Indukaev"
date: "Oct 24 2015"
output:
  html_document:
    keep_md: yes
---

## Project Description
This is the course project for the Getting and Cleaning Data class on Coursera by John Hopkins University.
The data is provided by UC Irvine Machine Learning Repository and is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) or [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

##Study design and data processing

###Collection of the raw data
(Based on the original dataset info):

The experiments have been carried out with a group of 30 volunteers. Each subject performed each of the six activities  (Walking, Walking upstairs, Walking downstairs, Sitting, Standing, Laying), while wearing a smartphone on the waist. This amounted to 30 x 6 = 180 experiments.

During each of the 180 experiments, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz using the smartphone's built-in accelerometer and gyroscope. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and the remaining 30% for the test data.

The sensor signals (accelerometer and gyroscope) were first pre-processed by applying noise filters.

Each of the 180 experiments was then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). Thus each given experiment produced 36 to 95 records (rows) to the dataset, according to the number of sliding windows that fit in the timeframe of the experiment.

The sensor acceleration signal, consists of gravitational and body motion components,. The two components were separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force was assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.

Then Fast Fourier Transform (FFT) was applied to some of the signals, producing additional signals in the frequency domain.

Then from each window, a vector of features was obtained by calculating 17 statistics (mean(), std(), min(), max(), etc) for 33 signals (23 signals in the time domain and 10 signals in the frequency domain) in different combinations. The total number of measure variables obtained this way is 561. As strange as it may sound, the fact that 561 = 17 x 33 = #statistics x #signals seems to be a mere coincidence, as,  in general, different statistics are applicable to different signals and some are calculated basing on two signals.

Each record (row) in the train and test datasets corresponds to the 561 variables calculated within one 2.56 sec window (128 readings at 50 readings per sec) of a single subject performing a single activity. The train and test datasets contain the total of 10299 records.

##Creating the tidy datafile

###Guide to create the tidy data file
1. Download the dataset [here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip) or [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Unzip the zipped file to your computer.
3. [Download run_analysis.R script](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/run_analysis.R)  from this repository. 
4. Open the downloaded script in your R development environment.
5. Set the working directory to your "UCI HAR Dataset" directory created in step 2. For example, `setwd("C:/DSS/UCI HAR Dataset/")` 
6. Make sure `dplyr` package is installed. If not, install it by entering `install.packages("dplyr")` in your R console.
7. Run the script. The tidy dataset `X_avgs` will be created in your environment and a file named `X_avgs.txt` containing it will be created in your working directory. 

###Cleaning of the data
The script reads the all the neccesary data into R data frames and prepares the data. It merges all data into one big data set, using descriptive variable names. It drops all the columns not needed for the analysis, leaving only `mean()` and `std()` out of the 17 statistics. After this step we obtain a dataset of 10 299 rows and 68 columns.

The script then performs the analysis, averaging all the measure variables over each subject and each activity, as specified in the assignment. This produces the tidy dataset `X_avgs`, which is also written in `X_avgs.txt` file in the working directory/

For more detailed description see [README.md](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/README.md) and the comments inside the [script](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/run_analysis.R).

##Description of the variables in the `X_avgs.txt` file

The tidy dataset `X_avgs.txt` contains 180 rows and 68 columns.

Each row in the tidy dataset corresponds to one experiment (one subject performig one activity), and vice versa.

###Subject
A `factor` variable containing subject id `"1"` to `"30"`.

###Activity
A `factor` variable containing activity label ("Walking', "Walking upstairs", "Walking downstairs", "Sitting', "Standing", "Laying").

###Other 66 variables

The remaining 66 columns vontain averages of mean() and std() statistics of all 33 signals, taken over each subject and activity.

The variable names have several levels.

*Level 1 contains either the letter `t` or the letter `f`. The `t` means the variable is in the temporal domain, `f` indicates the frequency domain.
* Level 2 is either `Body` or `Gravity` and indicates whether the variable relates to body motion or  gravitational component of a signal.
* Level 3 contains one of te following: 
  *`Acc` - acceleration;
  *`Accjerk` - derivative of acceleration aka jerk;
  *`Gyro` - angular velocity;
  *`Gyrojerk` - derivative of angular velocity aka angular jerk;
  *`AccMag` - Euclidean norm of acceleration;
  *`AccjerkMag` - Euclidean norm of jerk;
  *`GyroMag` -  - Euclidean norm of angular velocity;
  *`GyrojerkMag` - Euclidean norm of angular jerk;
* Level 4 contains either `mean` or `std`.
* Level 5 is either absent (for `*Mag` variables), or contains the name of the axis the variable relates to - `X`, `Y`, or `Z`.

##Units of measurement:
No units because all measure variables are normalized.

####Notes on variables:
Features in the raw data were normalized and bounded within [-1,1].



##Sources

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


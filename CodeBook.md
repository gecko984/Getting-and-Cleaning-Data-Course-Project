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

During each of the 180 experiments, 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz using the smartphone's embedded accelerometer and gyroscope. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and the remaining 30% for the test data.

The sensor signals (accelerometer and gyroscope) were first pre-processed by applying noise filters.

Each of the 180 experiments was then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). Thus each given experiment produced 36 to 95 records (rows) to the dataset, according to the number of sliding windows that fit in the timeframe of the experiment.

The sensor acceleration signal, which is considered as consisting of gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force was assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.

Then Fast Fourier Transform (FFT) was applied to some of the signals, producing signals in the frequency domain.

Then from each window, a vector of features was obtained by calculating 17 statistics (mean, std, min, max, etc) of 33 signals (20 signals in the time domain and 13 signals in the frequency domain). This amounted to 33 x 17 = 561 measure variables in the dataset.

Each record (row) in the train and test datasets corresponds to the 561 variables calculated within one 2.56 sec timeframe (128 readings at 50 readings per sec) of a single subject performing a single activity. The train and test datasets contain the total of 10299 records, implying an average of 10299 / 180 = 57.22 records per experiment.

##Creating the tidy datafile

###Guide to create the tidy data file
1. Download the dataset [here](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip) or [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Unzip the zipped file to your computer.
3. [Download run_analysis.R script](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/run_analysis.R)  from this repository. 
4. Open the downloaded script in your R development environment.
5. Set the working directory to your "UCI HAR Dataset" directory created in step 2. For example, `setwd("C:/DSS/UCI HAR Dataset/")` 
6. Make sure `dplyr` package is installed. If not, install it by entering `install.packages("dplyr")` in your R console.
7. Run the script. The tidy dataset `X_avgs` will be created in your environment and a file named `X_avgs.txt` will be created in your working directory. 



###Cleaning of the data
The script reads the all the neccesary data into R data frames and prepares the data. It merges all data into one big data set, using descriptive variable names. It drops all the columns not needed for the analysis. AFter this step we obtain a dataset of 10 299 rows on 68 columns. Each row represents an observation of one subject performing one type of activity. For any given subject and activity, there are several rows of data.
The script then performs the analysis, averaging out all the variables over each subject and each activity, as specified in the assignment. This produces the tidy dataset `X_avgs`, which is also written in `X_avgs.txt` file in the working directory/

For more detailed description see [README.md](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/README.md) and the comments inside the [script](https://github.com/gecko984/Getting-and-Cleaning-Data-Course-Project/blob/master/run_analysis.R).

##Description of the variables in the `X_avgs.txt` file

The tidy dataset `X_avgs.txt` contains 180 rows and 68 columns.
The first two columns are "Subject" and "Activity". They are of 'factor' class and contain subject id's and activity label for each observation.

The remaining 66 columns contain gyroscope and accelerometer data from the original dataset, averaged over each subject and activity

General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes.

Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors. Describe these 4 levels). 

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

####Notes on variable 1:
If available, some additional notes on the variable not covered elsewehere. If no notes are present leave this section out.

##Sources
Sources you used if any, otherise leave out.

##Annex
If you used any code in the codebook that had the echo=FALSE attribute post this here (make sure you set the results parameter to 'hide' as you do not want the results to show again)

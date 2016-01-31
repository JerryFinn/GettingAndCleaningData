#
# Author: Jerry Finn
# Date: 31-January-2016
# For Coursera Getting and Cleaning Data Course

# install.packages("dplyr")
library(dplyr)

#
# Create a data directory for working in. Then down load the zip file and unzip it. 
#
if(!file.exists("./data")) {dir.create("./data")}
setwd("./data/")
fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename1 = "ph.zip"
download.file(fileURL ,destfile = filename1, mode = 'wb')
unzip(filename1)
 
#
# As a sanity check see if a couple expected directories exist and if not, end the execution
#

if (!file.exists("./UCI HAR Dataset/test/Inertial Signals") | !file.exists("./UCI HAR Dataset/train/Inertial Signals")) {
    stop("Expected directories don't exit.")
}

#
# Check if the files we need exist before preceded. If not end execution
#

if (file.exists("./UCI HAR Dataset/train/X_train.txt") & file.exists("./UCI HAR Dataset/test/X_test.txt") &
    file.exists("./UCI HAR Dataset/train/y_train.txt") & file.exists("./UCI HAR Dataset/test/y_test.txt") &
    file.exists("./UCI HAR Dataset/train/subject_train.txt") & file.exists("./UCI HAR Dataset/test/subject_test.txt")) {

    # Instruction 1
    # Merge the Training and Testing dataset readings into merged set with rbind
    #
    X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
    X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
    X_merge_temp <- rbind(X_train, X_test)
    
    #
    # Merge the Training and Testing labels into merged set with rbind
    #
    y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
    y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")
    y_merge <- rbind(y_train, y_test)
    
    #
    # Merge the Training and Testing subjects into merged set with rbind
    #
    subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
    subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
    subject_merge <- rbind(subject_train, subject_test)
} else {
    stop("Files to merge don't exist")
}

# Instruction 4
# The features file has descriptive name that we can use as columns names
# First verify the file exists
#
if (file.exists("./UCI HAR Dataset/features.txt")) {
    features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
    # 
    # If the number of features = the columns then go ahead and name the columns
    #  
    if (nrow(features) == ncol(X_merge_temp)) {
        names(X_merge_temp) <- features[[2]]    
    } else {
        stop("features and columns not equal as expected")
    }
    
    # Instruction 2
    # Create an data frame with only mean and standard deviation measurements
    #
    column_nums <- c(grep("(mean\\(|std\\()", names(X_merge_temp)))
    X_merge <- X_merge_temp[,column_nums]
    
    # Make activity a character, not factor so you can change the value later
    X_merge$activity <- as.character(y_merge$V1)
    X_merge$subject <- as.factor(subject_merge$V1)     
} else {
    stop("features.txt file does not exist")
} 

# Instruction 3
# Replace activity number with the description
#
if (file.exists("./UCI HAR Dataset/activity_labels.txt")) {
    activity <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)
    activity$V1 <- as.character(activity$V1)
    for(i in activity$V1) {
        X_merge$activity[X_merge$activity == i] <- activity$V2[activity$V1 == i]
    }
} else { 
    stop("activity_labels.txt does not exist")
}

# Instruction 5
# Make a tidy data set and writ it out
# Finally write out the merged data set with activiy description, subject and column names
# File is spaced delimited, not fixed width
#
tidydataset <- X_merge %>% group_by(activity, subject)  %>% summarise_each(funs(mean))
if(!file.exists("./merge")) {dir.create("./merge")}
write.table(tidydataset, file ="./merge/tidydataset.txt", quote = FALSE, row.name=FALSE)
write.table(X_merge, file = "./merge/MergedCleaned.txt", quote = FALSE, row.name=FALSE)

print("End of Script -- Execution successful")

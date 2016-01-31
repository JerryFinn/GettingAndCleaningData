# GettingAndCleaningData

1. Create a data directory for working in. Then down load the zip file and unzip it. The zip file will be named "ph.zip"

2. During the process we will take the following Training and Testing sets and merge them all into 1 file for the observations.  
"./UCI HAR Dataset/train/X_train.txt" and "./UCI HAR Dataset/test/X_test.txt"
"./UCI HAR Dataset/train/y_train.txt" and "./UCI HAR Dataset/test/y_test.txt" - these have the activity label code
"./UCI HAR Dataset/train/subject_train.txt" and "./UCI HAR Dataset/test/subject_test.txt" - number 1 to 30 or subject doing activity
"./UCI HAR Dataset/activity_labels.txt" - Text for activity 
"./UCI HAR Dataset/features.txt" - This will provide column names for the merged data set. 

3. Always check if the files we need exist before preceeding. If not end execution

4. The data sets will merged into tables where "train" or "test" is replaced with "merge"

5. The "X_" sets will be merged to X_merge_temp where the column names will be changed and then only the mean and std columns be copied to X_merge table

6. Then the "y_" and "subject_" will be appended to table X_merge. This the data set we want and it will be written to space delimited file MergedClean.txt at the end of the script.

7. In the for loop replace the activity number with the text description

8. We then create a tidy data set that groups by activity and subject and get the mean for each column of those combinations.

9. Write the tidydataset to ./merge/tidydataset.txt file

10. End execution. 


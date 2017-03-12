library(reshape2)


## To set the zip data set, and the URL to download from, a short name we will use afterwards
file <- "FUCI HAR Dataset.zip"
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


## To download the dataset:

download.file(URL, file)


## To unzip the dataset:

unzip("FUCI HAR Dataset.zip")


## To load activity labels and features. We set the format of column No. 2 to character. 
ActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
ActivityLabels[,2] <- as.character(ActivityLabels[,2])
Features <- read.table("UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])


## To extract only the measurements on the mean and standard deviation
FeaturesWanted <- grep(".*mean.*|.*std.*", Features[,2])
FeaturesWanted.names <- Features[FeaturesWanted,2]
FeaturesWanted.names = gsub('-mean', 'Mean', FeaturesWanted.names)
FeaturesWanted.names = gsub('-std', 'Std', FeaturesWanted.names)
FeaturesWanted.names <- gsub('[-()]', '', FeaturesWanted.names)


## To load the datasets (X_train.txt, Y_train.txt, subject_train.txt) and put them together using
## cbind into "Train" 
Train <- read.table("UCI HAR Dataset/train/X_train.txt")[FeaturesWanted]
TrainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
TrainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
Train <- cbind(TrainSubjects, TrainActivities, Train)


## To load the datasets (X_test.txt, Y_test.txt, subject_test.txt) and put them together using
## cbinf into "Test"
Test <- read.table("UCI HAR Dataset/test/X_test.txt")[FeaturesWanted]
TestActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
TestSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
Test <- cbind(TestSubjects, TestActivities, Test)


## To merge both datasets "Train" and "Test" and to add labels to them 
MergedData <- rbind(Train, Test)
colnames(MergedData) <- c("subject", "activity", FeaturesWanted.names)


## To turn activities & subjects into factors
MergedData$activity <- factor(MergedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
MergedData$subject <- as.factor(MergedData$subject)

MergedData.Melted <- melt(MergedData, id = c("subject", "activity"))
MergedData.Mean <- dcast(MergedData.Melted, subject + activity ~ variable, mean)


## To write a table called "tidy.txt"
write.table(MergedData.Mean, "tidy.txt", row.names = FALSE, quote = FALSE)
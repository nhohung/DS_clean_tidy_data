# Preload libraries and set up directories

setwd("./UCI HAR Dataset")
library(plyr)     # for join commmand
library(tidyr)    # for gather command
library(dplyr)    # for group_by command

## ======================================================================

# 1. Load train and test sets
trainX <- read.csv("./train/X_train.txt", header = FALSE, sep = "")
trainY <- read.csv("./train/Y_train.txt", header = FALSE)
trainSubj <- read.csv("./train/subject_train.txt", header = FALSE)
testX <- read.csv("./test/X_test.txt", header = FALSE, sep = "")
testY <- read.csv("./test/Y_test.txt", header = FALSE)
testSubj <- read.csv("./test/subject_test.txt", header = FALSE)

# 2. Add a column to indicate which dataset (train/test) the data belong, before merging
trainX$train_test <- "train"
testX$train_test <- "test"

# 3. Merge X, Y, Subject to both data
testMerge <- cbind(testX,testY,testSubj)
trainMerge <- cbind(trainX,trainY,trainSubj)
# Merge test + train to dt:
dt <- rbind(testMerge,trainMerge)

## THIS IS THE END OF QUESTION 1
## ======================================================================

# 4. Some modification on merged data
# Assign column names from 'features.txt', change the last 2 columns to "Y" and "Subject"
features <- read.csv("./features.txt", header = FALSE, sep = " ")
names(dt) <- c(as.character(features[,2]),"train_test","Y","Subject")

# Assign activity with corresponding features
activity <- read.csv("./activity_labels.txt", header = FALSE, sep = " ")
names(activity) <- c("Y", "Activity")
dt$Y <- as.integer(dt$Y)
data <- join(dt,activity, by = "Y")

## THIS IS THE END OF QUESTION 3
## ======================================================================

# 5. Extract mean, standard deviation measurements
name <- names(data)
extr <- grepl("[Mm]ean|std",name)
extract <- cbind(data[,extr],data$train_test,data$Y,data$Subject,data$Activity)

## THIS IS THE END OF QUESTION 2
## ======================================================================

# 6. Rename columns
# Rearrange columns: bring the last 4 columns to first
ncol(extract)
extract <- extract[c(87:90,1:86)]

# Start with the easiest, last columns
varName <- names(extract)
varName[1:4] <- c("Dataset","Label","Subject","Activity")

# remove (), Freq, duplicated Body, .1, angle to a
varName1 <- sub("\\()", "", varName)
varName2 <- sub("[Ff]req", "", varName1)
varName3 <- sub("BodyBody", "Body", varName2)
varName4 <- sub("\\.1", "", varName3)

names(extract) <- varName5

varName5 <- sub("angle", "a", varName4)

## THIS IS THE END OF QUESTION 4
## ======================================================================

# 7. Make tidy datasets
# a. Rearrange columns
extract1 <- extract[,c(1:34,45:71,88:90,35:44,72:87)]
# (For some reasons, the edited variable names are not copied, so I fixed them below)
varExtract1 <- names(extract1)
varExtract2 <- sub("\\.1", "", varExtract1)
names(extract1) <- varExtract2

# b. Tidy columns with (X, Y, Z)
extract2 <- extract1[,c(1:61)]     # columns with X, Y, Z
res1 <- gather(extract2, key = Measurement, value = Value, -c("Dataset","Label","Subject","Activity"))

# c. Tidy columns with (mean, std)
extract3 <- extract1[,c(1:4,62:90)]     # columns with mean, std
res2 <- gather(extract3, key = Measurement, value = Value, -c("Dataset","Label","Subject (volunteer)","Activity"))

# d. Combine tidy (X, Y, Z) and (mean, std)
tidyData <- rbind(res1,res2)

# Factorize columns and check results
cols <- c("Dataset", "Label", "Subject (volunteer)","Activity", "Measurement")
tidyData[cols] <- lapply(tidyData[cols], factor)

# Remove "Label" (because it's now represented by "State")
tidyData1 <- tidyData[,-2,drop=FALSE]

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData2 <- tidyData1 %>% group_by(Dataset, Subject, Activity, Measurement) %>% summarise_at(vars(Value), mean)
names(tidyData2)[5] <- 'Mean_Summarized'

## THIS IS THE END OF QUESTION 5
## ======================================================================

# Export datasets to hard drive
write.csv(extract, "extract.csv")
write.csv(tidyData2, "tidyData2.csv")
write.table(extract, file = "extract.txt", row.names = FALSE)
write.table(tidyData2, file = "tidyData2.txt", row.names = FALSE)

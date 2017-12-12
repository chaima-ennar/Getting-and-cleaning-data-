library(data.table)
library(reshape2)
library(stringr)
# reading the  data
activity_labels <- fread(col.names=c("classLables","activityNames"),"UCI HAR Dataset/activity_labels.txt")
activity_labels

features <- fread(col.names = c("pointer", "featureNames"),"UCI HAR Dataset/features.txt")
#Searching for mean and standard deviation for each measurement

featuresSearched<- grep(".*mean.*|.*std.*", features[,featureNames])
measurements <- features[featuresSearched, featureNames]
measurements
measurements <- gsub('[-()]','', measurements)
measurements <-gsub('mean', 'Mean', measurements)
measurements<-gsub('std', 'Std', measurements)
# reading the  data
train <- fread("UCI HAR Dataset/train/X_train.txt")[, featuresSearched, with = FALSE]
train
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(col.names = c("Activity"),"UCI HAR Dataset/train/y_train.txt")
trainActivities                   
trainSubjects <- fread(col.names = c("SubjectIdentifier"),"UCI HAR Dataset/train/subject_train.txt")
trainSubjects     
#binding the data 
train <- cbind(trainSubjects, trainActivities, train)
test <- fread("UCI HAR Dataset/test/X_test.txt")[, featuresSearched, with = FALSE]
test
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(col.names = c("Activity"),"UCI HAR Dataset/test/y_test.txt")
# reading and binding the data
testSubjects <- fread(col.names = c("SubjectIdentifier"),"UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)
test
BindedData <- rbind(train, test)
BindedData

BindedData$Activity <- factor(BindedData$Activity, levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])
BindedData
allData$Subject <- as.factor(allData$subject)

BindedDataCombine<- melt(BindedData, id = c("SubjectIdentifier", "Activity"))
BindedDataCombine<- dcast(BindedData.melted, SubjectIdentifier+ Activity ~ variable, mean)

write.table(BindedDataCombine, "tidy.txt", row.names = FALSE, quote = FALSE)




BindedDataCombine

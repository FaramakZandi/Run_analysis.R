# 1 
library(dplyr)
if (!file.exists("cdt.zip")){
  fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "C:/Users/faramak/Desktop/sft/cdt.zip")
}

unzip(zipfile="C:/Users/faramak/Desktop/sft/cdt.zip")

Ytrn<- read.table("UCI HAR Dataset/train/Y_train.txt")
Ytst  <- read.table("UCI HAR Dataset/test/Y_test.txt")
Xtrn<- read.table("UCI HAR Dataset/train/X_train.txt")
Xtst  <- read.table("UCI HAR Dataset/test/X_test.txt")
sbtrn <- read.table("UCI HAR Dataset/train/subject_train.txt")
sbtst<- read.table("UCI HAR Dataset/test/subject_test.txt")
Y <- rbind(Ytrn, Ytst)
X <- rbind(Xtrn, Xtst)
Sb <- rbind(sbtrn, sbtst)
mrg1 <- cbind(Sb, Y, X)
str(mrg1)
# 2

fr <- read.table("UCI HAR Dataset/features.txt")
names(X)<- fr[,2]
fr3 <- grep("-mean\\(\\)|-std\\(\\)", fr[, 2])
# fr3 <- grep("mean|std)", fr[, 2])
NX<- X[, fr3]
names(NX)<- fr[fr3,2]
names(NX)<-  gsub("_","",names(NX))
names(NX) <- gsub("\\(|\\)", "", names(NX))
names(NX)<-  tolower(names(NX))
NX
# 3

lb <- read.table("UCI HAR Dataset/activity_labels.txt")
lb
lb[, 2] <- gsub("_", "", tolower(lb[, 2]))
NY <- merge( Y, lb , by="V1", all.x=TRUE)
names(NY) <- c("V1","lb")
names(Sb)<-c("sb")
mrg2 <- cbind(Sb,NY, NX)
# 4 

names(mrg2)<-gsub("mean()", "mean", names(mrg2))
names(mrg2)<-gsub("std()", "sd", names(mrg2))
names(mrg2)<-gsub("mag", "Magnitude", names(mrg2))
names(mrg2)<-gsub("acc", "Accelerometer", names(mrg2))
names(mrg2)<-gsub("gyro", "Gyroscope", names(mrg2))
names(mrg2)<-gsub("bodybody", "Body", names(mrg2))
names(mrg2)<-gsub("^t", "time", names(mrg2))
names(mrg2)<-gsub("^f", "frequency", names(mrg2))
str(mrg2)
# 5

mrg3 <- mrg2 %>%
  group_by(sb, lb) %>%
  summarise_all(funs(mean))
write.table(mrg3, "mrg3.txt", row.name=FALSE)

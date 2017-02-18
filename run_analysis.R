
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")

datosActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
datosActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
datosSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
datosSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
datosFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
datosFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

datosSubject <- rbind(datosSubjectTrain, datosSubjectTest)
datosActivity<- rbind(datosActivityTrain, datosActivityTest)
datosFeatures<- rbind(datosFeaturesTrain, datosFeaturesTest)
names(datosSubject)<-c("subject")
names(datosActivity)<- c("activity")
datosFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(datosFeatures)<- dataFeaturesNames$V2
datosCombinados <- cbind(datosSubject, datosActivity)
Data <- cbind(datosFeatures, datosCombinados)
subdatosFeaturesNames<-datosFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", datosFeaturesNames$V2)]
selectedNames<-c(as.character(subdatosFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
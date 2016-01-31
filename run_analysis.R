> # download the data.
> setwd('/Users/落/Documents/UCI HAR Dataset/');
> 
> featureso=read.table('./features.txt',header=FALSE); 
> activitytype=read.table('./activity_labels.txt',header=FALSE); 
> subjecttrain=read.table('./train/subject_train.txt',header=FALSE); 
> xtrain=read.table('./train/x_train.txt',header=FALSE); 
> ytrain=read.table('./train/y_train.txt',header=FALSE); 
> subjecttest=read.table('./test/subject_test.txt',header=FALSE); 
> xtest=read.table('./test/x_test.txt',header=FALSE); 
> ytest=read.table('./test/y_test.txt',header=FALSE); 
> 
> #Extracts only the measurements on the mean and standard deviation for each measurement.
> features <- grep("-(mean|std)\\(\\)", featureso[, 2])
> 
> colnames(activitytype)=c('activityId','activitytype');
> colnames(subjecttrain)="subjectId";
> colnames(xtrain)=featureso[,2]; 
> colnames(ytrain)="activityId";
> colnames(subjecttest)="subjectId";
> colnames(xtest)=featureso[,2]; 
> colnames(ytest)="activityId";
> 
> # Merger the test and training data to on data set named FD
> 
> training=cbind(ytrain,subjecttrain,xtrain);
> test=cbind(ytest,subjecttest,xtest);
> FD=rbind(training,test);
> 
> # Uses descriptive activity names to name the activities in the data set.
> FD$activityId <- as.character(FD$activityId)
> FD$activityId[FD$activityId==1]<-“WALKING”
> FD$activityId[FD$activityId==2]<-“WALKING UPSTAIRS”
> FD$activityId[FD$activityId==3]<-“WALKING DOWNSTAIRS”
> FD$activityId[FD$activityId==4]<-“SITTING”
> FD$activityId[FD$activityId==5]<-“STANDING”
> FD$activityId[FD$activityId==6]<-“LAYING”
> 
> #Appropriately labels the data set with descriptive variable names.
> names(FD) <- gsub("Acc", "Accelerator", names(FD))
> names(FD) <- gsub("Mag", "Magnitude", names(FD))
> names(FD) <- gsub("Gyro", "Gyroscope", names(FD))
> names(FD) <- gsub("^t", "Time", names(FD))
> names(FD) <- gsub("^f", "Frequency", names(FD))
> 
> #From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
> CN<- colnames(FD); 
> library(reshape2)
> FD.melted <- melt(FD, id = c("subjectId", "activityId"),measure.vars=CN);
> FD.mean <- dcast(FD.melted, subjectId + activityId ~ variable, mean);
> write.table(FD.mean, "tidy.txt", row.names = FALSE)

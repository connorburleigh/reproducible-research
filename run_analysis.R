## Getting and Cleaning Data Course Project Script
url<-"http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
wd<-getwd()
download.file(url,paste(wd,"UCI_HAR_Dataset.zip",sep="/"),method="curl")
unz(paste(wd,"UCI_HAR_Dataset.zip",sep="/")
    setwd(paste(wd,"UCI_HAR_Dataset",sep="/"))
    trainx<-read.table(paste(wd,"train","X_train.txt", sep="/"))
    trainy<-read.table(paste(wd,"train","Y_train.txt", sep="/"))
    testx<-read.table(paste(wd,"test","X_test.txt", sep="/"))
    testy<-read.table(paste(wd,"test","Y_test.txt", sep="/"))
    subjecttrain<-read.table(paste(wd,"train","subject_train.txt", sep="/"))
    subjecttest<-read.table(paste(wd,"test","subject_test.txt", sep="/"))
    train<-cbind(subjecttrain,trainy,trainx)
    test<-cbind(subjecttest,testy,testx)
    alldata<-rbind(train,test)
    features<-read.table(paste(wd,"features.txt",sep="/"),stringsAsFactors=FALSE)
    varnames<-features[,2]
    temp<-data.frame("subject_id","activity_labels",stringsAsFactors=FALSE)
    varlist<-as.list(varnames)
    fullList<-append(temp, varlist)
    colnames(alldata) <- fullList
    ##alldata is the "tidy data set"
    
    ## Create and index for columns including the terms mean and std from varnames
    ## and then transform the index to include the Activity Labels and IDs
    meanStdColumns <- grep("mean|std", varnames, value = FALSE)
    transform<-meanStdColumns+2
    ColumnIndex<-c(1,2,transform)
    extractedData<-alldata[,ColumnIndex]
    
    
    ## extratedData is the values for columns containing mean and std,
    ##  and will now be adjusted to include the activity labels.
    extractedData$activity_labels[extractedData$activity_labels==1]<-"WALKING"
    extractedData$activity_labels[extractedData$activity_labels==2]<-"WALKING_UPSTAIRS"
    extractedData$activity_labels[extractedData$activity_labels==3]<-"WALKING_DOWNSTAIRS"
    extractedData$activity_labels[extractedData$activity_labels==4]<-"SITTING"
    extractedData$activity_labels[extractedData$activity_labels==5]<-"STANDING"
    extractedData$activity_labels[extractedData$activity_labels==6]<-"LAYING"
    
    ## extractedData already contains the descriptive names, as per step 4 instructions
    ## as they were applied in step 1, so we will proceed to step 5.
    
    ## create an index column to break the data down by ID and Activity, then use the 
    ## aggregate function to apply get the averages across all groups and create a new table.
    extractedData$index_column = paste(extractedData$subject_id, extractedData$activity_label, sep = "_" )
    summarydata<-aggregate(extractedData[3:81], by=list(extractedData$index_column), FUN=mean)
    write.table(summarydata,paste(wd,"Tidy Data.txt",sep="/"),row.name=FALSE)
    
    
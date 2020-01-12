library(dplyr)

#reading all training data sets
x_train <- read.table("x_train.txt")
y_train <- read.table("y_train.txt")
s_train <- read.table("subject_train.txt")

#reading the variable names for file X
var_names <- read.table("features.txt")

#reading all test data sets
x_test <- read.table("x_test.txt")
y_test <- read.table("y_test.txt")
s_test <- read.table("subject_test.txt")

#reading the factors for the codes in the Y file
act_labels <- read.table("activity_labels.txt")

#combining the training and test data sets to a single file
X <- rbind(x_train, x_test)
names(X) <- var_names[,2] #naming the columns from file read in line 9
Y <- rbind(y_train, y_test)
names(Y) <- "activity"
Y$activity <- factor(Y$activity,labels = as.character(act_labels[,2])) #converting the code names to factor names from the file read in line 17
S <- rbind(s_train, s_test)
names(S) <- "subject"

#getting only the mean and std variables 
names_onlymeanstd <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
X <- X[,names_onlymeanstd[,1]] #filtering only the mean and std variables

tidy <- cbind(X,Y,S) #combining the mean std values, activity and the subject
tidy_2 <- tidy %>% group_by(activity,subject) %>% summarise_each(funs(mean)) #summarizing the means of each variable based on activity > subject
write.table(tidy_2,file = "tidydata.txt",row.names = FALSE,col.names = TRUE) #saving the file

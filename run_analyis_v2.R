library(dplyr)

# Merges the training and the test sets to create one data set
features <- read.table("dataset/features.txt", col.names = c("index","functions"))
activities <- read.table("dataset/activity_labels.txt", col.names = c("type", "activity"))
x_test <- read.table("dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("dataset/test/y_test.txt", col.names = "type")
subject_test <- read.table("dataset/test/subject_test.txt", col.names = "subject")
x_train <- read.table("dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("dataset/train/y_train.txt", col.names = "type")
subject_train <- read.table("dataset/train/subject_train.txt", col.names = "subject")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(subject, y, x)

# Extracts only the measurements on the mean and standard deviation for each measurement
select_data <- merged_data %>% select(subject, type, contains("mean"), contains("std"))
select_data <- select_data %>% mutate(type = activities[type,2])
names(select_data)[1] = "Subject"
names(select_data)[2] = "Activity"

# Creates a second, independent tidy data set
out_data <- select_data %>% group_by(Subject, Activity) %>% summarise_all(mean)
write.table(out_data, file = "output.txt", row.names = FALSE)
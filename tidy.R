# Step 1: Load required libraries
library(dplyr)

# Step 2: Load the data
# Paths to the data files
train_data_path <- "UCI HAR Dataset/train/X_train.txt"
train_labels_path <- "UCI HAR Dataset/train/y_train.txt"
train_subject_path <- "UCI HAR Dataset/train/subject_train.txt"
test_data_path <- "UCI HAR Dataset/test/X_test.txt"
test_labels_path <- "UCI HAR Dataset/test/y_test.txt"
test_subject_path <- "UCI HAR Dataset/test/subject_test.txt"
features_path <- "UCI HAR Dataset/features.txt"
activity_labels_path <- "UCI HAR Dataset/activity_labels.txt"

# Load the datasets
train_data <- read.table(train_data_path)
train_labels <- read.table(train_labels_path)
train_subject <- read.table(train_subject_path)
test_data <- read.table(test_data_path)
test_labels <- read.table(test_labels_path)
test_subject <- read.table(test_subject_path)
features <- read.table(features_path)
activity_labels <- read.table(activity_labels_path)

# Step 3: Merge the training and test data sets
data <- rbind(cbind(train_subject, train_labels, train_data),
              cbind(test_subject, test_labels, test_data))

# Step 4: Extract the measurements on the mean and standard deviation
# Get the indices of the features containing mean() or std()
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)
data <- data[, c(1, 2, mean_std_indices + 2)]  # +2 to account for subject and activity columns

# Step 5: Use descriptive activity names
data$V2 <- factor(data$V2, levels = 1:6, labels = activity_labels$V2)

# Step 6: Label the data set with descriptive variable names
colnames(data) <- c("Subject", "Activity", as.character(features$V2[mean_std_indices]))

# Step 7: Create a tidy data set with the average of each variable for each activity and each subject
tidy_data <- data %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean = ~mean(.)))

# Step 8: Write the tidy data set to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)

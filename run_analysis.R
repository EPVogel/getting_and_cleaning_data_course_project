library(dplyr)
#Set the path of the files
#setwd("The directory in which the data is saved")

#load the data from the files 

#Read feature labels. Table contains a single column with the 561 features
df_features <- read.table("UCI HAR Dataset/features.txt") %>% tbl_df %>% mutate(feature = as.character(V2)) %>% select(feature)
#Read activity names
df_activity <- read.table("UCI HAR Dataset/activity_labels.txt") %>% tbl_df %>% mutate(activity_id = as.integer(V1), activity = as.character(V2)) %>% select(activity_id, activity)

#Read test data
df_data_test <- read.table("UCI HAR Dataset/test/X_test.txt") %>% tbl_df 
df_label_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "\t") %>% tbl_df %>% mutate(activity_id = as.integer(V1)) %>% select(activity_id)
df_subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "\t") %>% tbl_df

#Read train data
df_data_train <- read.table("UCI HAR Dataset/train/X_train.txt") %>% tbl_df 
df_label_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "\t") %>% tbl_df %>% mutate(activity_id = as.integer(V1)) %>% select(activity_id)
df_subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "\t") %>% tbl_df


#merge datasets and assign column names from the feature file
df_data <-  bind_rows(df_data_train, df_data_test)
names(df_data) <- df_features[["feature"]]

#merge label data
df_labels <-  bind_rows(df_label_train, df_label_test)

#merge subject data
df_subjects <- bind_rows(df_subjects_train, df_subjects_test)
names(df_subjects) <- c("subject")

#2 select mean and standard deviation only by using a regular expression
# on the column names
df_data_reduced <- df_data[grepl("(-mean)|(Mean)|(-std)", names(df_data))]


#3 Replace acitivity ids with the activity names and add the subject and activity column to the dataset
df_labels <- inner_join(df_labels, df_activity) %>% select(activity)
df_data_reduced <- bind_cols(df_subjects,df_labels,df_data_reduced)

#5 Create a new independet tidy dataset with the average of each variable for each activity
df_data_averaged <- df_data_reduced %>%group_by(subject, activity) %>% summarize_all(funs(mean)) %>% arrange(subject)
write.table(df_data_averaged, file = "tidy_data.txt", row.name = FALSE)
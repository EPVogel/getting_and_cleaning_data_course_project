# Code book for the **Getting and Cleaning Data Course Project**
Project work for Coursera Course 

All the processing steps described below are executed in the **run_analysis.R** script. All paths are relative to the root data directory **UCI HAR Dataset**.

## Raw data tha is processed

From the data directory the following files are used. The unprocessed raw data in the **Inertial Signals** subdirectory is not used.

* **features.txt**
* **activity_labels.txt**
* **test/X_test.txt**
* **test/y_test.txt**
* **test/subject_test.txt**
* **train/X_train.txt**
* **train/y_train.txt**
* **train/subject_train.txt**

## Data processing

### Feature names

Features are read from **features.txt** into a dataframe df_features. The single column is cast into a character vector and is named **feature**.

### Activity labels

Activity labels are read from **activity_labels.txt** into a dataframe df_activity. The first column is cast into an integer vector and is named **activity_id**. The second column is cast into a character vector and is named **activity**.

### Test data

* The test data **test/X_test.txt** is stored in a dataframe df_data_test.
* The test labels are read from **test/y_test.txt** and stored in a dataframe **df_label_test**. The single column is cast into an integer vector and is named **activity_id**.
* The test subjects are read from **test/subject_test.txt** and stored in a dataframe **df_subjects_test**.


### Train data

* The train data **train/X_train.txt** is stored in a dataframe df_data_train.
* The train labels are read from **train/y_train.txt** and stored in a dataframe **df_label_train**. The single column is cast into an integer vector and is named **activity_id**.
* The train subjects are read from **train/subject_train.txt** and stored in a dataframe **df_subjects_train**.

### Merging

* The train and test dataset are merged into a single dateframe with the **bind_rows** function and stored in a dataframe **df_data**.
* The column names of **df_data** are replaced with the names stored in the **features** column of the dataframe **df_features**.
* From df_data only the columns containing the mean and standard deviation for each measurement are selected with grepl and the regular expression **(-mean)|(-std)** and stored in a new dataframe **df_reduced**.
* The labels and activity dataframes are joined by the activity_id. From the joined dataframe the activity column is selected and stored in the dataframe **df_labels**.
* The columns from the dataframes **df_subjects** and **df_labels** are attached to the left side of the **df_data_reduced** dataframe.

The resulting dataset in **df_data_reduced** contains the subject id (first column) and the activity (second column) as the measurement identifiers. All following columns contain the measured variables. Each measurement is stored in a single row.

## Export of new tidy data set

* The dataframe **df_data_reduced** is grouped by the columns subject and activity. The result is piped to the summarize_all function that computes the average value for all variable columns. The result is stored in a dataframe **df_data_averaged**.
* The dataframe **df_data_averaged** is exported with the write_table function to a file **tidy_data.txt** - the row id is ommited from the result.
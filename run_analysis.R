library(dplyr)
library(stringr)

load_activity_label <- function() {
  read.table(
             'data/activity_labels.txt', 
             col.names=c("code", "label"), 
             stringsAsFactors=FALSE
             ) %>% 
          mutate(label = tolower(label)) %>%
          pull(label)
}

load_feature <- function() {
  read.table(
             'data/features.txt', 
             col.names=c("code", "feature"), 
             stringsAsFactors=FALSE
             ) %>%
          mutate(feature = gsub("\\(\\)", "", feature)) %>%
          mutate(feature = gsub("-",".", feature)) %>%
          pull(feature)
}


load_dataset <- function(set, act_label, feature) {
  path <- paste('data', set, sep='/')

  subject  <- read.table(
                         paste(path,'/','subject_',set,'.txt', sep=''), 
                         col.names=c("subject")
                         )$subject
  activity <- read.table( paste(path,'/','y_',set,'.txt', sep=''), col.names=c("code")) %>% 
                mutate(activity = act_label[code]) %>%
                pull(activity)

  data <- read.table(paste(path,'/','X_',set,'.txt', sep=''), col.names = feature)

  dataset <- factor(rep(set, nrow(data)), levels=c("test","train"))

  data.frame(subject, dataset, activity, data) 
}

which_derivation <- function(var) {
  dv = c("base", "jerk", "magiture")
  ms = c()
}

act_label <- load_activity_labels()
act_label

# loading default column names for the raw dataset
feature  <- load_feature()

test     <- load_dataset('test', act_label, feature)
train    <- load_dataset('train', act_label, feature)

# Step 1: merge test and train dataset
merge_data <- bind_rows(test, train)

base_cols   = c("subject", "dataset", "activity")
select_cols = grep("(mean|std)(\\.|$)", feature, value=TRUE)

# Step 2: Extracts only the measurements on the mean and standard deviation
select_dataset <- merge_data %>% 
                    select( c(base_cols,select_cols) )

# Step 3: Used descriptive activity names to name the activites in the dataset (done in load_dataset)
print(select_cols)

# Step 4: Approriately labels the dataset with descriptive variable names
melt_dataset <- melt(select_dataset, id=base_cols, measure.vars=select_cols)
melt_dataset$sensor <- as.character(melt_dataset$variable)
head(melt_dataset$sensor)

        #mutate(filter = factor( str_detect(signal, ".Body"), labels = c("gravity", "body") )) %>%
        #mutate(domain = factor( str_detect(signal, "^t"), labels = c("frequency", "time") )) %>%
        #mutate(sensor = factor( str_detect(signal, ".Acc"), labels = c("gyro", "accel") )) %>%
        #mutate(axial = factor( substr(signal, nchar(signal),nchar(signal)) )) %>%

dataset <- melt_dataset %>%
        mutate(variable = factor( str_detect(sensor, "\\.mean"), labels = c("std", "mean") )) %>%
        mutate(sensor = factor( str_replace(sensor, "\\.(mean|std)(\\.|$)", "") ))
head(dataset)
# Step 5: create a second, independent tidy data set with the average of each variable 
#         of each activity and each subject

avg_subj_act <- dataset %>%
        mutate(subject_activity = factor(paste('subject', subject, activity, sep='_' ))) %>%
        dcast(subject_activity ~ variable, mean)
head(avg_subj_act, 50)

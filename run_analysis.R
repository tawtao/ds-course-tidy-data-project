library(dplyr)
library(reshape2)
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
          mutate(feature = gsub("BodyBody", "Body", feature)) %>%
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
  data.frame(subject, activity, data) 
}

act_label <- load_activity_label()
feature   <- load_feature()
# load test and train dataset with descriptive activity name and columns names.
test  <- load_dataset('test', act_label, feature)
train <- load_dataset('train', act_label, feature)

# merge test and train dataset
merge_ds <- bind_rows(test, train) 

id_cols     = names(merge_ds)[1:2]
select_cols = grep("(mean|std)(\\.|$)", feature, value=TRUE)

# Extracts only the measurements on the mean and standard deviation
select_ds <- merge_ds %>% 
  select( c(id_cols, select_cols) )

# Create dataset with factor colum 'variable' with labels "mean", "std", 
# and factor column 'sensor' with labels mutate from select_cols by removing "mean", and "std" words.
melt_ds <- melt(select_ds, id=id_cols, measure.vars=select_cols)
melt_ds$signal <- as.character(melt_ds$variable)

tidy_ds <- melt_ds %>%
          mutate(domain   = factor( str_detect(signal, "^t"), labels=c("freq", "time") )) %>%
          mutate(filter   = factor( str_detect(signal, "Body"), labels=c("gravity", "body") )) %>%
          mutate(sensor   = factor( str_detect(signal, "Acc"), labels=c("gyro", "accel") )) %>%
          mutate(axial    = factor( substr(signal, nchar(signal), nchar(signal) ) )) %>%
          mutate(variable = factor( str_detect(signal, "mean"), labels=c("std", "mean") )) %>%
          mutate(jerk = factor( str_detect(signal, "Jerk"), labels=c("no", "yes") )) %>%
          mutate(magniture = factor( str_detect(signal, "Mag"), labels=c("no", "yes") )) %>%
          select(-signal)

# Create a second, independent tidy data set with the average of each variable 
# of each activity and each subject
mean_ds <- tidy_ds %>%
        group_by(subject, activity) %>%
        summarize(mean = mean(value))

head(mean_ds)

write.table(mean_ds, file="mean_dataset.txt", row.names=FALSE)


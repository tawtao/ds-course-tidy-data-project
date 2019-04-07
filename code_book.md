## Data Science Specialist Course: Tidy Data Project

#### Step 4: Tidy dataset 
The tidy dataset, resulted in step 4, has 4 columns.
* **subject**:  A number to identify the subject who carried out the experiment
  * values: integer from 1 to 6
* **activity**: An activity that subject done in the experiment. See
  [activity_labels.txt](UCI%20HAR%20Dataset/activity_labels.txt) for more information.
  * values: ``walking, walking_upstairs, walking_downstairs, sitting, standing, laying``
* **variable**: A variable that were estimated from signals. See
  [features_info.txt](UCI%20HAR%20Dataset/features_info.txt) for more information.
  * values: mean = mean value, std = standard deviation
* **value**: The value of variable of the signals 
  * values: numeric
* **sensor**: The sensor that estimated the signals. See
  [features_info.txt](UCI%20HAR%20Dataset/features_info.txt) for more information.
  * values: The values is from the features listed in [features.txt](UCI%20HAR%20Dataset/features.txt), and
    then removed "mean()" and "std()" from the feature name. For example ``tBodyAcc-mean()-X`` become
    ``tBodyAccX``, etc.

#### Step 5: Average dataset
The final dataset is the result of average over variable ``mean`` and ``std`` for each subject **and**
activity. There are 3 columns in this dataset:
* **subject_activity**: It is a combine col between ``subject`` and ``activity`` columns. 
  * values: A value is a string combine subject column with activity with prefix ``subject``. For example
  for subject ``2`` and activity ``laying``, the combine value is ``subject_2_laying``
* **mean_of_std**: a value of average of standard deviation.
  * values: numeric
* **mean_of_mean**: a value of average of mean.
  * values: numeric

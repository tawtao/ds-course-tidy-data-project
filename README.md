## Data Science Specialist Course: Tidy Data Project

This project contains R script that perform tidy and analysis on ``UCI HAR Dataset`` in subdirectory ``UCI HAR
Dataset``. It has a link ``data`, please don't remove it.

The script is in ``run_analysis.R``, and the [code_book.md](code_book.md) described the dataset in detail.

#### Running the script: 
This R script was developed under R version 3.5.3 (2019-03-11) on linux. The
simpliest way to run the script is to open command line and change directory to the directory that contain
``run_analysis.R`` and issue command 

```$ Rscript run_analysis.R ``` 

The script will create text file named
``average_of_mean_And_std_over_subject_and_activity.txt``. Also the script will print out some part datasets.

#### Inner working of the script: The script is using packages ``dplyr``,``reshape2`` and ``stringr``

There are five steps within the script:
1. loading ``test`` and ``train`` dataset. The loading is perform by function ``load_dataset``.  The function
   take three parameters. The first one is set, which can be either 'test' or 'train'. This set is used to
select which part of UCI HAR Dataset to be loaded. The result is assign a variable ``test`` and ``train``,
respectively.  
  Other two paramsters are ``act_label`` and ``feature`` are vectors of activity labels and feature names
described in ``data/activity_labels.txt`` and ``data/features.txt`` respectively. The ``act_label`` is
used to create a column ``activity`` with discritive activity values. The ``feature`` becomes the column
name of the dataset. While the feature is getting loaded by fuction ``load_feature``, the value of the feature
get simplify by remove ``()`` and change ``-`` to ``.``.
1. After loadling ``test`` and ``train`` dataset with proper activity value and column name. The second step
   is to merge test and train togeter. It is done by function ``bind_rows`` and create a new dataset,
``merge_ds``.
1. The next step is to extract only the measurements on the mean and standard deviation for each sensor. It is
   done by create id_cols, a vector of "subject" and "activity", and select_cols, a vector of the column that
have ".mean", and ".std" and ending with "." or end of string. The using this two vectors to create
``select_ds`` from the ``merge_ds`` from step 2
1. Using ``melt`` to create ``melt_ds``, then we create separate variable ``mean`` and ``std`` from the other
   ``sensor`` variables. The result is almost tidy dataset with described in [code_book.txt](code_book.txt).
from Since we do not analyze data on other variables other than ``mean`` and ``std``, there is no need to tidy
the data further.
1. The last step is to calculate the mean of each variables on subject and activity. This is done by combine
   the subject and activity into one factor, named ``subject_activity``. The value of this column is the
combination of value of subject and activity columns which described in the [code_book.txt](code_book.txt).
Then using ``dcast`` function to calculate the mean of mean and std. At the end, the columns are named
appropriately.
  

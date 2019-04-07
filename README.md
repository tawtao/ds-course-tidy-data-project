## Data Science Specialist Course: Tidy Data Project

This project contains R script that perform tidy and analysis on ``UCI HAR Dataset`` in subdirectory ``data``

The script is in ``run_analysis.R``, and the [code_book.md](code_book.md) described the result dataset in
detail.  

#### File list:
 * README.md: This file.
 * run_analysis.R: The analysis R-script file.
 * code_book.md: The code_book describes the result dataset.
 * mean_dataset.txt: The result dataset.

#### Running the script: 

The R script was developed under R version 3.5.3 (2019-03-11) on linux. The simpliest way to run the script is
to open command line and change directory to the directory that contain ``run_analysis.R`` and issue command 

```$ Rscript run_analysis.R ``` 

The script will create text file named ``mean_dataset.txt``, as described in [codebook.txt](codebook.txt).

#### Inner working of the script: 

The script is using packages ``dplyr``,``reshape2`` and ``stringr``

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
1. Using ``melt`` to create ``melt_ds``, which create two columns, variable and value. Using the column
   variable, now we can tidy the dataset clean and meaningful way by create separate columns for each sensor
realed attributes, 
  * domain, a factor of "time" and "freq", 
  * sensor, a factor of "gyro" and "accel",
  * filter, a factor of "gravity" and "body",
  * axial, a factor of sensor axial, with values "X", "Y" and "Z"
  * variable, a factor of variables that were estimated from these signals, see
  [features_info.txt](data/features_info.txt) for more detail  Anyway, those tidy data steps are not required
to finished the project.
1. The last step is to calculate the mean of each variables on subject and activity. This is done by combine
   the subject and activity into one factor using ``group_by``, and then calculate mean over the value.
  

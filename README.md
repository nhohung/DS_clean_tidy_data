Hello! Below is the descriptions of my work in Clean, tidy data (Coursera course), I'll show you how I code the `run_analysis.R` file to complete the assignment.

Also, the two exported files are **extract.csv** for the first 4 questions (clean up data), and **tidyData2.csv** for the last question (tidy up data).

**=============**

_Code lines 1-6 load the needed libraries_

_Code lines 10-16 load the data files_

### Clean data: The first 4 questions
**Data overview:**

The original data is:

	train set:
	
		X: 7352 rows, 561 cols
		
		Y: 7352 rows,   1 cols
		
	test set:
	
		X: 2497 rows, 561 cols
		
		Y: 2497 rows,   1 cols

The train data contains 7352 samples, each with 561 measurements.

The test data contains 2497 samples, each with 561 measurements.

**Add dataset type (code lines 18-20)**

Before merging these datasets, I add another column to each of them, indicating whether each sample belongs to train or test set. The new column is "train_test" and is valued "train"/"test" accordingly.

**Merge data (code lines 22-26)**

For each train/test set, I first merge X, Y and Subject (the volunteer) together using `cbind`.

Then I merge train and test sets together using `rbind`.

The data after merging has a total of 10299 samples, each with 561 measurements. Dimension of merged data is 10299 x 564 (3 columns are **Y**, **Subject** and **train/test**).

_This would be the end of Question 1._

**Assign activity (code lines 31-40)**

The next step is to assign Activity from Y value, based on the corresponding information in **activity_labels.txt**.

I first load **activity_labels.txt**, and name the **code** as **Y** to match the merged data.

Then I assign the activity for each sample by `join`ing the activity labels with the merged data, the referenced column is **Y**. _(code line 40)_

The merged data now has another column **Activity**, total of 565.

_This would be the end of Question 3._

**Extract part of dataset (code lines 45-48)**

The next part is to extract all measurements on the mean and standard deviation for each sample.

I first extract the column names of the latest data.

I then find in these names which one has string "Mean"/"mean"/"std" (using `grepl` command) and extract them from the data.

The data now has only 90 columns, 86 of them are measurements of mean and standard deviation.

_This would be the end of Question 2._

**Rename variable names (code lines 53-70)**

To make the variable names more informative, I perform the following steps:

- bring the last 4 columns to the leftmost and rename them to: "Dataset","Label","Subject","Activity".

- among the remaining, I
		
		delete string "()" because they're redundant
	
		delete string "Freq" because they're already represented by prefix f
	
		delete one of the duplicated string "BodyBody"
	
		delete string ".1" because they're meaningless
	
		replace prefix string "angle" to "a" for prefix consistency (t, f, a)
	
(all of these operations are done using `sub` command)

_This would be the end of Question 4._

### Tidy up data: Question 5 (code lines 75-103)

- first rearrange the columns, now follow: 4 reference information, 57 XYZ data measurements and 29 mean/std data measurements (total of 90 columns).

- then expand all measurements with respect to reference information in XYZ and mean/std data (using `gather` command, apply on all columns except the 4 reference columns)

- then merge these 2 restructured data together (using `rbin`)

		The data now has this structure:

			4 reference columns

			1 column of measurement type

			1 column of corresponding measurement value

		Its dimension now becomes: 885714 x 6.

- for cleaning up, I factorize all columns (using `lapply`) and remove column **Label** because it's already represented by **Activity**.

		The data dimension is now 885714 x 5.

- __(important)__ to create the independent dataset with the average of each variable for each activity and each subject, I use the **summarise_at** argument in `group_by` command, apply on **Value** of measurements.  _(code line 102)_

		The data dimension is now 15480 x 5.

- I also changed the last column name from **Value** to **Mean_Summarized** to give descriptive meaning

_This would be the end of Question 5._

### Export data (code lines 108-110)

The last commands are for exporting the dataset to csv files.

**extract.csv**: for cleaned data

**tidyData2.csv**: for tidied data

**=============**

I hope you can follow my description, if there is something not clear, please give me comments.

Thanks for grading my assignment.

Hung

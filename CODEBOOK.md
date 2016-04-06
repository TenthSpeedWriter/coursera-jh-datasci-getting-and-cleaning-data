# Getting & Cleaning Data
    CODEBOOK

## Data Description

Each row in the formatted dataset represents a single sample of kinetic statistics from a single known subject performing a single known class of activity.

## Variables

There exist 4 types of data in this table:
* **-mean()** and **-sd()** of each tracked kinetic parameter - as numeric values.
* subject - Integer ID of the subject tracked in this sample
* target - The activity performed by the subject during this sample

Data are grouped by both subject and target for the purposes of this exercise; however, one with experience in kinetic measurements could quite easily further group them by the real-world values they represent.

## Analysis

In addition to the dataset, this script exports as a CSV the mean values for each kinetic measurement across each subject involved and activity performed.

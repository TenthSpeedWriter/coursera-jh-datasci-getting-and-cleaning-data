### Data origin: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
library(dplyr)

# Default directory for the given file structure
DATA_DIRECTORY <- "UCI HAR Dataset"


# Pull the labels for X from features.txt, transpose them to a horizontal
# arrangement, then cast them to a simple character vector
X_label_data <- read.table("UCI HAR Dataset/features.txt",
                           stringsAsFactors = F)[2]
X_labels <- as.character(t(X_label_data))

y_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)

# Loads either the Train or Test Set.
# Default is Train, but set_name should be explicitly declared for clarity.
load_set <- function(set_name = "train") {
  # Wraps requested filename with set's suffix and filetype extension before
  # loading it using load_method
  load_file <- function(partial_filename,
                        filetype = ".txt",
                        load_method = read.table) {
    filename <- paste(DATA_DIRECTORY,
                      "/", set_name,
                      "/", partial_filename,
                      "_", set_name,
                      filetype, sep="")
    load_method(filename)
  }
  
  # Apply label names
  X_raw <- load_file("X")
  names(X_raw) <- X_labels
  
  # Append subjectID and y target columns
  subjectIDs <- load_file("subject")[, 1]
  X_raw$subject <- subjectIDs
  
  # Append the target activity variables
  targets <- load_file("y")[, 1]
  X_raw$target <- targets
  
  # Replace each value in the target column its corresponding activity string 
  # from activity_labels.txt
  X_raw$target <- sapply(X_raw$target,
                         function(target_id) {
                           y_labels[target_id, 2]
                         })
  
  X_raw
}


desired_col_name_regex <- paste("-mean()",
                                "-std()",
                                "target",
                                "subject", sep="|")
load_comprehensive_dataset <- function() {
  # Use grepl to extract column names from the here-defined types.
  extract_desired_columns <- function(table_) {
    matching_names <- names(table_)[grepl(x = names(table_),
                                          pattern = desired_col_name_regex)]
    
    table_[, matching_names]
  }
  
  load_desired_data <- function(set_name = "train") {
    data <- load_set(set_name) %>% extract_desired_columns()
  }
  
  train_set <- load_desired_data("train") 
  test_set <- load_desired_data("test")
  
  rbind(train_set, test_set)
}

run_analysis <- function() {
  data <- load_comprehensive_dataset() %>% group_by(subject, target)
  stats <- summarise_each(data, funs(mean))
  
  list(data=data,
       stats=stats)
}

# Convenience function to perform the analysis and export the results to CSV
export_results <- function(data_path="tidy_data.txt",
                           stats_path="statistics.txt") {
  analytical_result <- run_analysis()
  
  write.table(x = analytical_result$data,
              file = data_path,
              row.name = F)
  write.table(x=analytical_result$stats,
              file = stats_path,
              row.name = F)
}
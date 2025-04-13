# clean_data.R
"
Clean heart attack dataset and save the processed version.
Usage:
  clean_data.R --input=<input_file> --output=<output_file>
" -> doc

library(docopt)
library(dplyr)
library(readr)
library(heartpredictr)

args <- docopt(doc)

# Read data
heart_attack_data <- read_csv(args$input)

# Clean data: Remove unnecessary columns and convert categorical variables
heart_attack_data_clean <- clean_heart_data(heart_attack_data)

# Save cleaned data
write_csv(heart_attack_data_clean, args$output)

print("Data cleaning completed and saved.")
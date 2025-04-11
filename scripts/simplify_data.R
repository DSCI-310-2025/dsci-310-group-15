"
Create a simplified dataset using significant variables.
Usage:
  simplify_data.R --input=<input_file> --output=<output_file>
" -> doc

# Load required libraries
library(docopt)
library(dplyr)
library(readr)

# Parse command-line arguments
args <- docopt(doc)

# Read the cleaned dataset
heart_attack_data_clean <- read_csv(args$input)

# Select only significant variables
heart_attack_data_simplified <- heart_attack_data_clean |>
    select(Age, Alcohol_Consumption, LDL_Level, Emergency_Response_Time, Heart_Attack_Risk)

# Save the simplified dataset
write_csv(heart_attack_data_simplified, args$output)

"
Extract significant variables from the logistic regression model.
Usage:
  model_sig.R --input=<input_file> --output=<output_file>
" -> doc

# Load required libraries
library(docopt)
library(dplyr)
library(readr)
library(broom)
library(heartpredictr)

# Parse command-line arguments
args <- docopt(doc)

# Read the cleaned dataset
heart_attack_data_clean <- read_csv(args$input)

# Extract significant variables (p-value < 0.15) in logistic regression model
significant_vars <- significant_vars <- get_significant_variables(heart_attack_data_clean, target = "Heart_Attack_Risk", p_thresh = 0.15)

# Save significant variables to a CSV file
write_csv(data.frame(Significant_Variables = significant_vars), args$output)

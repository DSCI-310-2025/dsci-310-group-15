"
Train a logistic regression model on heart attack dataset.
Usage:
  model_summary.R --input=<input_file> --output=<output_file>
" -> doc

# Load required libraries
library(docopt)
library(dplyr)
library(readr)
library(broom)

# Parse command-line arguments
args <- docopt(doc)

# Read the cleaned dataset
heart_attack_data_clean <- read_csv(args$input)

# Train a logistic regression model
heart_attack_model <- glm(Heart_Attack_Risk ~ .,
                          data = heart_attack_data_clean,
                          family = binomial(link = 'logit'))

# Extract model results
heart_attack_model_result <- 
    tidy(heart_attack_model, conf.int = TRUE) |> 
    mutate_if(is.numeric, round, 2)

# Save results to CSV
write_csv(heart_attack_model_result, args$output)
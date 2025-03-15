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

# Parse command-line arguments
args <- docopt(doc)

# Read the cleaned dataset
heart_attack_data_clean <- read_csv(args$input)

# Train logistic regression model
heart_attack_model <- glm(Heart_Attack_Risk ~ .,
                          data = heart_attack_data_clean,
                          family = binomial(link = 'logit'))

# Extract significant variables (p-value < 0.15)
significant_vars <- tidy(heart_attack_model) |>
    filter(term != "(Intercept)" & p.value < 0.15) |>
    pull(term)

# Save significant variables to a CSV file
write_csv(data.frame(Significant_Variables = significant_vars), args$output)

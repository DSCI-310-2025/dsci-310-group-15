"
Train a simplified logistic regression model and calculate VIF.
Usage:
  model_vif.R --input=<input_file> --output=<output_file>
" -> doc

# Load required libraries
library(docopt)
library(dplyr)
library(readr)
library(broom)
library(car)  # For vif()

# Parse command-line arguments
args <- docopt(doc)

# Read the simplified dataset
heart_attack_data_simplified <- read_csv(args$input)

# Ensure categorical variables are factors
heart_attack_data_simplified <- heart_attack_data_simplified |>
    mutate(Heart_Attack_Risk = as.factor(Heart_Attack_Risk))

# Train logistic regression model
heart_attack_simplified_model <- glm(
    Heart_Attack_Risk ~ .,
    data = heart_attack_data_simplified,
    family = binomial(link = "logit")
)

# Compute Variance Inflation Factor (VIF)
vif_values <- vif(heart_attack_simplified_model)

# Convert VIF values into a data frame for saving
vif_df <- data.frame(Variable = names(vif_values), VIF = vif_values)

# Save VIF results
write_csv(vif_df, args$output)
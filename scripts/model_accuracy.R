"
Train logistic regression model using train-test split and compute accuracy.
Usage:
  model_accuracy.R --input=<input_file> --output=<accuracy_output>
" -> doc

# Load required libraries
library(docopt)
library(dplyr)
library(readr)
library(caret)  # For confusionMatrix()

# Parse command-line arguments
args <- docopt(doc)

# Read the simplified dataset
heart_attack_data_simplified <- read_csv(args$input)

# Ensure categorical variables are treated correctly
heart_attack_data_simplified <- heart_attack_data_simplified |>
    mutate(Heart_Attack_Risk = as.factor(Heart_Attack_Risk))

# Set seed for reproducibility
set.seed(123)

# Split the dataset (70% training, 30% testing)
data_split <- createDataPartition(heart_attack_data_simplified$Heart_Attack_Risk,
                                  p = 0.7, list = FALSE)
train_data <- heart_attack_data_simplified[data_split, ]
test_data <- heart_attack_data_simplified[-data_split, ]

# Train logistic regression model
heart_attack_simplified_model <- glm(
    Heart_Attack_Risk ~ .,
    data = train_data,
    family = binomial
)

# Make predictions on the test set
predicted_prob <- predict(heart_attack_simplified_model, newdata = test_data, type = "response")
predicted_labels <- ifelse(predicted_prob > 0.5, 1, 0)

# Compute accuracy only (no confusion matrix)
accuracy <- mean(predicted_labels == test_data$Heart_Attack_Risk)

# Save accuracy as a CSV file
write_csv(data.frame(Model_Accuracy = accuracy), args$output)

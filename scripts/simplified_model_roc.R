"
Compute ROC curve and AUC for the simplified logistic regression model.
Usage:
  simplified_model_roc.R --input=<input_file> --output_auc=<output_auc> --output_roc=<output_roc>
" -> doc

# Load required libraries
library(docopt)
library(caret)
library(randomForest)
library(readr)
library(dplyr)
library(ggplot2)
library(pROC)

# Parse command-line arguments
args <- docopt(doc)

# Read the simplified dataset
heart_attack_data_simplified <- read_csv(args$input)

# Ensure categorical variables are factors
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
simplified_model <- glm(
    Heart_Attack_Risk ~ .,
    data = train_data,
    family = binomial
)

# Make probability predictions
predicted_prob <- predict(simplified_model, newdata = test_data, type = "response")

# Compute ROC curve
roc_curve <- roc(test_data$Heart_Attack_Risk, predicted_prob)
auc_value <- auc(roc_curve)

# Save AUC to a CSV file
write_csv(data.frame(AUC_Value = auc_value), args$output_auc)

# Save ROC plot
png(args$output_roc, width = 800, height = 600)
plot(roc_curve, main = "ROC Curve of Simplified Model", col = "red", lwd = 2)
dev.off()
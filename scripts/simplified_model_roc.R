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
library(heartpredictr)

# Parse command-line arguments
args <- docopt(doc)

# Read the simplified dataset
heart_attack_data_simplified <- read_csv(args$input)

# Ensure categorical variables are factors
splits <- prepare_heart_data(file_path = args$input,
                             target_col = "Heart_Attack_Risk",
                             train_ratio = 0.7,
                             random_seed = 123)

train_data <- splits$train_data
test_data  <- splits$test_data

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
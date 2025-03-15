"
Train a Random Forest model and evaluate using ROC AUC.
Usage:
  random_forest_model.R --input=<input_file> --auc_output=<auc_output> --roc_output=<roc_output>
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

# Ensure categorical variables are treated correctly
heart_attack_data_simplified <- heart_attack_data_simplified |>
    mutate(Heart_Attack_Risk = as.factor(Heart_Attack_Risk))

# Set seed for reproducibility
set.seed(123)

# Split the dataset (70% training, 30% testing)
data_split <- createDataPartition(heart_attack_data_simplified$Heart_Attack_Risk,
                                  p = 0.7, list = FALSE)
train_data <- heart_attack_data_simplified[data_split, ]
test_data <- heart_attack_data_simplified[data_split, ]

# Convert target variable to factor (if not already)
train_data$Heart_Attack_Risk <- as.factor(train_data$Heart_Attack_Risk)
test_data$Heart_Attack_Risk <- as.factor(test_data$Heart_Attack_Risk)

# Train Random Forest model
rf_model <- randomForest(
    Heart_Attack_Risk ~ .,
    data = train_data,
    ntree = 150,
    mtry = 1
)

# Make probability predictions
predicted_prob_rf <- predict(rf_model, newdata = test_data, type = "prob")[, 2]

# Compute ROC curve and AUC value
roc_curve_rf <- roc(test_data$Heart_Attack_Risk, predicted_prob_rf)
auc_value_rf <- auc(roc_curve_rf)

# Save AUC to a CSV file
write_csv(data.frame(Random_Forest_AUC = auc_value_rf), args$auc_output)

# Save ROC plot
png(args$roc_output, width = 800, height = 600)
plot(roc_curve_rf, main = "Random Forest ROC Curve", col = 'red', lwd = 2)
dev.off()
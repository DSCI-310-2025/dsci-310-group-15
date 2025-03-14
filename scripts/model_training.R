# model_training.R
"
Train models and save results.
Usage:
  model_training.R --input=<input_file> --output1=<output_plot1> --output2=<output_plot2>
" -> doc

library(docopt)
library(caret)
library(randomForest)
library(readr)
library(dplyr)
library(ggplot2)
library(pROC)

args <- docopt(doc)

# Read data
heart_attack_data <- read_csv(args$input)

# Split data
set.seed(123)
train_index <- createDataPartition(heart_attack_data$Heart_Attack_Risk, p = 0.7, list = FALSE)
train_data <- heart_attack_data[train_index, ]
test_data <- heart_attack_data[-train_index, ]

# Logistic Regression
logit_model <- glm(Heart_Attack_Risk ~ ., data = train_data, family = binomial())
logit_pred <- predict(logit_model, newdata = test_data, type = "response")

# Generate ROC Curve for Logistic Regression
roc_curve_logit <- roc(test_data$Heart_Attack_Risk, logit_pred)
auc_value_logit <- auc(roc_curve_logit)

# Save logistic regression ROC curve
logit_plot <- ggplot(data.frame(fpr = 1 - roc_curve_logit$specificities, 
                                tpr = roc_curve_logit$sensitivities), aes(x = fpr, y = tpr)) +
  geom_line(color = "blue") +
  labs(title = "ROC Curve for Logistic Regression", x = "False Positive Rate", y = "True Positive Rate") +
  theme_minimal()

ggsave(args$output1, plot = logit_plot)

print(paste("Logistic Regression Model Training Completed. AUC:", auc_value_logit))

# Random Forest Model
train_data$Heart_Attack_Risk <- as.factor(train_data$Heart_Attack_Risk)
test_data$Heart_Attack_Risk <- as.factor(test_data$Heart_Attack_Risk)

set.seed(123)
rf_model <- randomForest(Heart_Attack_Risk ~ ., data = train_data, ntree = 150)
rf_pred <- predict(rf_model, newdata = test_data, type = "prob")[,2]

# Generate ROC Curve for Random Forest
roc_curve_rf <- roc(test_data$Heart_Attack_Risk, rf_pred)
auc_value_rf <- auc(roc_curve_rf)

# Save random forest ROC curve
rf_plot <- ggplot(data.frame(fpr = 1 - roc_curve_rf$specificities, 
                             tpr = roc_curve_rf$sensitivities), aes(x = fpr, y = tpr)) +
  geom_line(color = "red") +
  labs(title = "ROC Curve for Random Forest", x = "False Positive Rate", y = "True Positive Rate") +
  theme_minimal()

ggsave(args$output2, plot = rf_plot)

print(paste("Random Forest Model Training Completed. AUC:", auc_value_rf))
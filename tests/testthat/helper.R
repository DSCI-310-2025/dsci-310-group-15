# Contains helper functions for model-related unit tests

library(tibble)

# Simulate a basic dataset with a binary outcome
make_fake_heart_data <- function(n = 10) {
  set.seed(123)
  tibble(
    Age = round(runif(n, 30, 80)),
    Cholesterol = round(rnorm(n, mean = 200, sd = 30)),
    Smoking = factor(sample(c(0, 1), n, replace = TRUE)),
    Alcohol_Consumption = factor(sample(c(0, 1), n, replace = TRUE)),
    Heart_Attack_Risk = factor(sample(c(0, 1), n, replace = TRUE))
  )
}

# Simulate a dataset with no significant predictors (for negative testing)
make_non_sig_data <- function(n = 10) {
  set.seed(456)
  tibble(
    Feature1 = runif(n),
    Feature2 = runif(n),
    Feature3 = runif(n),
    Heart_Attack_Risk = factor(sample(c(0, 1), n, replace = TRUE))
  )
}

# Simulate a dataset with missing values
make_data_with_nas <- function(n = 10) {
  df <- tibble::tibble(
    Age = sample(30:80, n, replace = TRUE),
    Cholesterol = round(rnorm(n, mean = 200, sd = 30)),
    Smoking = factor(sample(0:1, n, replace = TRUE)),
    Heart_Attack_Risk = factor(rep(c(0, 1), length.out = n))
  )
  df$Cholesterol[1] <- NA
  df
}

# Adapt test-clean_heart_data.R
make_heart_data <- function(n = 10) {
  tibble::tibble(
    Patient_ID = 1:n,
    State_Name = rep("CA", n),
    Gender = rep("M", n),
    Diabetes = sample(0:1, n, replace = TRUE),
    Hypertension = sample(0:1, n, replace = TRUE),
    Obesity = sample(0:1, n, replace = TRUE),
    Smoking = sample(0:1, n, replace = TRUE),
    Alcohol_Consumption = sample(0:1, n, replace = TRUE),
    Physical_Activity = sample(0:1, n, replace = TRUE),
    Air_Pollution_Exposure = sample(0:1, n, replace = TRUE),
    Family_History = sample(0:1, n, replace = TRUE),
    Heart_Attack_History = sample(0:1, n, replace = TRUE),
    Health_Insurance = sample(0:1, n, replace = TRUE),
    Heart_Attack_Risk = sample(0:1, n, replace = TRUE)
  )
}


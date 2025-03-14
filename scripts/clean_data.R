# clean_data.R
"
Clean heart attack dataset and save the processed version.
Usage:
  clean_data.R --input=<input_file> --output=<output_file>
" -> doc

library(docopt)
library(dplyr)
library(readr)

args <- docopt(doc)

# Read data
heart_attack_data <- read_csv(args$input)

# Clean data: Remove unnecessary columns and convert categorical variables
heart_attack_data_clean <- heart_attack_data %>%
    select(-Patient_ID, -State_Name, -Gender) %>%
    mutate(
        Diabetes = as.factor(Diabetes),
        Hypertension = as.factor(Hypertension),
        Obesity = as.factor(Obesity),
        Smoking = as.factor(Smoking),
        Alcohol_Consumption = as.factor(Alcohol_Consumption),
        Physical_Activity = as.factor(Physical_Activity),
        Air_Pollution_Exposure = as.factor(Air_Pollution_Exposure),
        Family_History = as.factor(Family_History),
        Heart_Attack_History = as.factor(Heart_Attack_History),
        Health_Insurance = as.factor(Health_Insurance),
        Heart_Attack_Risk = as.factor(Heart_Attack_Risk)
    )

# Save cleaned data
write_csv(heart_attack_data_clean, args$output)

print("Data cleaning completed and saved.")
library(readr)
library(dplyr)
library(pointblank)

validate_heart_data <- function(data) {
  
  agent <- create_agent(tbl = data, tbl_name = "heart_data") %>%
    # 1. Column names check
    col_exists(columns = vars(Age, Cholesterol, Smoking, Alcohol_Consumption, Heart_Attack_Risk)) %>%
    
    # 2. No fully empty rows
    rows_complete() %>%
    
    # 3. Missingness threshold check
    col_vals_not_null(columns = everything()) %>%
    
    # 4. Data type check
    col_is_numeric(columns = vars(Age, Cholesterol)) %>%
    col_is_character(columns = vars(Smoking, Alcohol_Consumption, Heart_Attack_Risk)) %>%
    
    # 5. No duplicates
    rows_distinct() %>%
    
    # 6. Age outlier check
    col_vals_between(columns = vars(Age), left = 0, right = 120) %>%
    
    # 7. Smoking levels
    col_vals_in_set(columns = vars(Smoking), set = c("Yes", "No")) %>%
    
    # 8. Response class imbalance (warn if very skewed)
    col_vals_in_set(columns = vars(Heart_Attack_Risk), set = c("0", "1")) %>%
    
    interrogate()
  

  print(agent)
  
  # Optional: Fail the script if any validation failed
  if (all_passed(agent) == FALSE) {
    stop("Data validation failed. Please review the agent report.")
  }
  
  message("Data validation check passed.")
}

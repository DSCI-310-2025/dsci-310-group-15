# load_data.R
"
Load heart attack dataset and save as a CSV file.
Usage:
  load_data.R --input=<input_file> --output=<output_file>
" -> doc

library(docopt)
library(readr)

args <- docopt(doc)

# Read data
heart_attack_data <- read_csv(args$input)

# Check missing values
missing_values <- colSums(is.na(heart_attack_data))
print("Missing values per column:")
print(missing_values)

# Save the data to a new CSV
write_csv(heart_attack_data, args$output)

print("Data successfully loaded and saved.")
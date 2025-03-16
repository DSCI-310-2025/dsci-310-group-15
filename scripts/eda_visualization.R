# eda_visualization.R
"
Perform EDA and save plots.

Usage:
  eda_visualization.R --input=<input_file> --output1=<output_plot1> --output2=<output_plot2>

Options:
  --input=<input_file>      Path to the input CSV file
  --output1=<output_plot1>  Path to save the correlation plot
  --output2=<output_plot2>  Path to save the correlation heatmap
" -> doc

# Load libraries
library(docopt)
library(ggplot2)
library(readr)
library(GGally)
library(tidyr)
library(dplyr)

# Parse command-line arguments
args <- docopt(doc)

# Ensure the "results" directory exists
if (!dir.exists("results")) {
    dir.create("results", recursive = TRUE)
}

# Read data
heart_attack_data <- read_csv(args$input)

# Generate correlation plot using GGally
eda_plot <- ggpairs(heart_attack_data)

# Save the correlation plot
ggsave(filename = args$output1, plot = eda_plot, width = 10, height = 8, dpi = 300)

# Convert factors to numeric for correlation matrix
heart_attack_data_numeric <- heart_attack_data %>%
    mutate(across(where(is.factor), as.numeric))

# Generate correlation matrix heatmap
cor_matrix <- cor(heart_attack_data_numeric)
cor_data <- as_tibble(cor_matrix, rownames = "var1") %>%
    pivot_longer(-var1, names_to = "var2", values_to = "corr")

cor_plot <- ggplot(cor_data, aes(x = var1, y = var2, fill = corr)) +
    geom_tile(color = "white") +
    geom_text(aes(label = round(corr, 2)), color = "black", size = 3) + 
    scale_fill_distiller(palette = "YlOrRd", direction = 1, limits = c(-1,1)) +
    labs(title = "Correlation Heatmap", x = "", y = "") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Save the correlation heatmap
ggsave(filename = args$output2, plot = cor_plot, width = 10, height = 8, dpi = 300)
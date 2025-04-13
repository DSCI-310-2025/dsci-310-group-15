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
library(heartpredictr)

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

# Generate correlation matrix heatmap
cor_plot <- create_correlation_heatmap(heart_attack_data)

# Save the correlation heatmap
ggsave(filename = args$output2, plot = cor_plot, width = 10, height = 8, dpi = 300)
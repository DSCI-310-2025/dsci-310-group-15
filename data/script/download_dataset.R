dir.create("data", showWarnings = FALSE, recursive = TRUE)

dataset_url <- "https://raw.githubusercontent.com/DSCI-310-2025/dsci-310-group-15/main/data/heart_attack_prediction_india.csv"
destination <- "data/heart_attack_prediction_india.csv"

if (!file.exists(destination)) {
  message("Downloading dataset from GitHub...")
  download.file(dataset_url, destfile = destination, method = "libcurl")
  message("✅ Dataset downloaded successfully!")
} else {
  message("📂 Dataset already exists. Skipping download.")
}

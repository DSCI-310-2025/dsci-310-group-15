# Define the final target: ensuring all results are produced
.PHONY: all clean

all: data/processed/processed_data.csv \
		data/processed/modeling_data.csv \
		data/processed/heart_attack_model_summary.csv \
		data/processed/significant_vars.csv \
		data/processed/heart_attack_data_simplified.csv \
		results/eda_pairplot.png \
		results/eda_corrplot.png \
		data/processed/heart_attack_vif.csv \
		data/processed/model_acc.csv \
		data/processed/simplified_model_auc.csv \
		results/simplified_model_roc.png \
		data/processed/random_forest_auc.csv \
		results/random_forest_roc.png \
		reports/heart-attack-prediction-analysis.html \
		reports/heart-attack-prediction-analysis.pdf

# Step 1: Load the raw data and processes it into a structured format.
data/processed/processed_data.csv: data/raw/heart_attack_prediction_india.csv scripts/load_data.R
	Rscript scripts/load_data.R \
	--input=data/raw/heart_attack_prediction_india.csv \
	--output=data/processed/processed_data.csv

# Step 2: Clean and preprocess the data, handling missing values and data transformations
data/processed/modeling_data.csv: data/processed/processed_data.csv scripts/clean_data.R
	Rscript scripts/clean_data.R \
	--input=data/processed/processed_data.csv \
	--output=data/processed/modeling_data.csv

# Step 3: Generate a summary of the statistical model built from the data
data/processed/heart_attack_model_summary.csv: data/processed/modeling_data.csv scripts/model_summary.R
	Rscript scripts/model_summary.R \
	--input=data/processed/modeling_data.csv \
	--output=data/processed/heart_attack_model_summary.csv

# Step 4: Identify the most significant predictors in the dataset
data/processed/significant_vars.csv: data/processed/modeling_data.csv scripts/model_sig.R
	Rscript scripts/model_sig.R \
	--input=data/processed/modeling_data.csv \
	--output=data/processed/significant_vars.csv

#step 5: Simplify the dataset by selecting only the most relevant features
data/processed/heart_attack_data_simplified.csv: data/processed/modeling_data.csv scripts/simplify_data.R
	Rscript scripts/simplify_data.R \
	--input=data/processed/modeling_data.csv \
	--output=data/processed/heart_attack_data_simplified.csv

# Step 6: Perform EDA and generate visualizations
results/eda_pairplot.png results/eda_corrplot.png: data/processed/heart_attack_data_simplified.csv scripts/eda_visualization.R
	Rscript scripts/eda_visualization.R \
	--input=data/processed/heart_attack_data_simplified.csv \
	--output1=results/eda_pairplot.png \
	--output2=results/eda_corrplot.png

# Step 7: Calculate Variance Inflation Factor (VIF)
data/processed/heart_attack_vif.csv: data/processed/heart_attack_data_simplified.csv scripts/model_vif.R
	Rscript scripts/model_vif.R \
	--input=data/processed/heart_attack_data_simplified.csv \
	--output=data/processed/heart_attack_vif.csv

# Step 8: Evaluate Model Accuracy
data/processed/model_acc.csv: data/processed/heart_attack_data_simplified.csv scripts/model_accuracy.R
	Rscript scripts/model_accuracy.R \
	--input=data/processed/heart_attack_data_simplified.csv \
	--output=data/processed/model_acc.csv

# Step 9: Train models and generate ROC curves
data/processed/simplified_model_auc.csv results/simplified_model_roc.png: data/processed/heart_attack_data_simplified.csv scripts/simplified_model_roc.R
	Rscript scripts/simplified_model_roc.R \
	--input=data/processed/heart_attack_data_simplified.csv \
	--output_auc=data/processed/simplified_model_auc.csv \
	--output_roc=results/simplified_model_roc.png

data/processed/random_forest_auc.csv results/random_forest_roc.png: data/processed/heart_attack_data_simplified.csv scripts/random_forest_model.R
	Rscript scripts/random_forest_model.R \
	--input=data/processed/heart_attack_data_simplified.csv \
	--auc_output=data/processed/random_forest_auc.csv \
	--roc_output=results/random_forest_roc.png

# render quarto report in HTML and PDF
reports/heart-attack-prediction-analysis.html: reports/heart-attack-prediction-analysis.qmd
	quarto render reports/heart-attack-prediction-analysis.qmd --to html

reports/heart-attack-prediction-analysis.pdf: reports/heart-attack-prediction-analysis.qmd
	quarto render reports/heart-attack-prediction-analysis.qmd --to pdf

# Clean all generated files
clean:
	rm -rf data/processed/*.csv
	rm -rf results/*.png
	rm -rf reports/heart-attack-prediction-analysis.html \
			reports/heart-attack-prediction-analysis.pdf 

# Test all tests
test:
	Rscript -e "testthat::test_dir('tests/testthat')"
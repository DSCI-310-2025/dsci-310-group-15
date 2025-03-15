# Define the final target: ensuring all results are produced
.PHONY: all clean

all: data/processed_data.csv \
		data/modeling_data.csv \
		data/heart_attack_model_summary.csv \
		data/significant_vars.csv \
		data/heart_attack_data_simplified.csv \
		results/eda_pairplot.png \
		results/eda_corrplot.png \
		data/heart_attack_vif.csv \
		data/model_acc.csv \
		data/simplified_model_auc.csv \
		results/simplified_model_roc.png \
		data/random_forest_auc.csv \
		results/random_forest_roc.png \
		reports/heart-attack-predication-analysis.html \
		report/heart-attack-predication-analysis.pdf

# Step 1: Load the raw data
data/processed_data.csv: data/heart_attack_prediction_india.csv scripts/load_data.R
	Rscript scripts/load_data.R \
	--input=data/heart_attack_prediction_india.csv \
	--output=data/processed_data.csv

# Step 2: Clean and preprocess the data
data/modeling_data.csv: data/processed_data.csv scripts/clean_data.R
	Rscript scripts/clean_data.R \
	--input=data/processed_data.csv \
	--output=data/modeling_data.csv

# Step 3
data/heart_attack_model_summary.csv: data/modeling_data.csv scripts/model_summary.R
	Rscript scripts/model_summary.R \
	--input=data/modeling_data.csv \
	--output=data/heart_attack_model_summary.csv

# Step 4
data/significant_vars.csv: data/modeling_data.csv scripts/model_sig.R
	Rscript scripts/model_sig.R \
	--input=data/modeling_data.csv \
	--output=data/significant_vars.csv

#step 5
data/heart_attack_data_simplified.csv: data/modeling_data.csv scripts/simplify_data.R
	Rscript scripts/simplify_data.R \
	--input=data/modeling_data.csv \
	--output=data/heart_attack_data_simplified.csv

# Step 6: Perform EDA and generate visualizations
results/eda_pairplot.png results/eda_corrplot.png: data/heart_attack_data_simplified.csv scripts/eda_visualization.R
	Rscript scripts/eda_visualization.R \
	--input=data/heart_attack_data_simplified.csv \
	--output1=results/eda_pairplot.png \
	--output2=results/eda_corrplot.png

# Step 7
data/heart_attack_vif.csv: data/heart_attack_data_simplified.csv scripts/model_vif.R
	Rscript scripts/model_vif.R \
	--input=data/heart_attack_data_simplified.csv \
	--output=data/heart_attack_vif.csv

# Step 8
data/model_acc.csv: data/heart_attack_data_simplified.csv scripts/model_accuracy.R
	Rscript scripts/model_accuracy.R \
	--input=data/heart_attack_data_simplified.csv \
	--output=data/model_acc.csv

# Step 9: Train models and generate ROC curves
data/simplified_model_auc.csv results/simplified_model_roc.png: data/heart_attack_data_simplified.csv scripts/simplified_model_roc.R
	Rscript scripts/simplified_model_roc.R \
	--input=data/heart_attack_data_simplified.csv \
	--output_auc=data/simplified_model_auc.csv \
	--output_roc=results/simplified_model_roc.png

data/random_forest_auc.csv results/random_forest_roc.png: data/heart_attack_data_simplified.csv scripts/random_forest_model.R
	Rscript scripts/random_forest_model.R \
	--input=data/heart_attack_data_simplified.csv \
	--auc_output=data/random_forest_auc.csv \
	--roc_output=results/random_forest_roc.png

# render quarto report in HTML and PDF
reports/heart-attack-predication-analysis.html: results reports/heart-attack-predication-analysis.qmd
	quarto render reports/heart-attack-predication-analysis.qmd --to html

reports/heart-attack-predication-analysis.pdf: results reports/heart-attack-predication-analysis.qmd
	quarto render reports/heart-attack-predication-analysis.qmd --to pdf

# Clean all generated files
clean:
	rm -rf data/processed_data.csv \
			data/modeling_data.csv \
			data/heart_attack_model_summary.csv \
			data/significant_vars.csv \
			data/heart_attack_data_simplified.csv \
			data/heart_attack_vif.csv \
			data/model_acc.csv \
			data/simplified_model_auc.csv \
			data/random_forest_auc.csv
	rm -rf results/*.png
	rm -rf reports/heart-attack-predication-analysis.html \
			reports/heart-attack-predication-analysis.pdf 
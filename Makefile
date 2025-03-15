# Define the final target: ensuring all results are produced
all: data/modeling_data.csv results/eda_pairplot.png results/eda_corrplot.png results/logistic_roc.png results/random_forest_roc.png 

# Step 1: Load the raw data
data/processed_data.csv: data/heart_attack_prediction_india.csv scripts/load_data.R
	Rscript scripts/load_data.R --input=data/heart_attack_prediction_india.csv --output=data/processed_data.csv

# Step 2: Clean and preprocess the data
data/modeling_data.csv: data/processed_data.csv scripts/clean_data.R
	Rscript scripts/clean_data.R --input=data/processed_data.csv --output=data/modeling_data.csv

# Step 2.1
data/heart_attack_model_summary.csv: data/modeling_data.csv scripts/model_summary.R
	Rscript scripts/model_summary.R --input=data/modeling_data.csv --output=data/heart_attack_model_summary.csv

# Step 2.2
data/significant_vars.csv: data/modeling_data.csv scripts/model_sig.R
	Rscript scripts/model_sig.R --input=data/modeling_data.csv --output=data/significant_vars.csv

#step 2.3
data/heart_attack_data_simplified.csv: data/modeling_data.csv scripts/simplify_data.R
	Rscript scripts/simplify_data.R --input=data/modeling_data.csv --output=data/heart_attack_data_simplified.csv

# Step 3: Perform EDA and generate visualizations
results/eda_pairplot.png results/eda_corrplot.png: data/modeling_data.csv scripts/eda_visualization.R
	Rscript scripts/eda_visualization.R --input=data/modeling_data.csv --output1=results/eda_pairplot.png --output2=results/eda_corrplot.png

# Step 3.1
data/heart_attack_vif.csv: data/heart_attack_data_simplified.csv scripts/model_vif.R
	Rscript scripts/model_vif.R --input=data/heart_attack_data_simplified.csv --output=data/heart_attack_vif.csv

# Step 3.2
data/model_acc.csv: data/heart_attack_data_simplified.csv scripts/model_accuracy.R
	Rscript scripts/model_accuracy.R --input=data/heart_attack_data_simplified.csv --output=data/model_acc.csv

# Step 4: Train models and generate ROC curves
results/logistic_roc.png results/random_forest_roc.png: data/modeling_data.csv scripts/model_training.R
	Rscript scripts/model_training.R --input=data/modeling_data.csv --output1=results/logistic_roc.png --output2=results/random_forest_roc.png

# render quarto report in HTML and PDF
reports/heart-attack-predication-analysis.html: results reports/heart-attack-predication-analysis.qmd
	quarto render reports/heart-attack-predication-analysis.qmd --to html

reports/heart-attack-predication-analysis.pdf: results reports/heart-attack-predication-analysis.qmd
	quarto render reports/heart-attack-predication-analysis.qmd --to pdf

# Clean all generated files
clean:
	rm -f data/processed_data.csv data/modeling_data.csv results/*.png
    rm -rf reports/heart-attack-predication-analysis.html reports/reports/heart-attack-predication-analysis.pdf reports/reports/heart-attack-predication-analysis_files
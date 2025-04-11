# Heart Attack Risk Prediction in India

## Authors: 
Chengyou Xiang, Junhao Wen, Peng Zhong, ZiXun Fang

## About
In this project, we attempt to build a classification model using machine learning techniques
to predict an individual's risk of experiencing a heart attack based on demographic, lifestyle,
and medical characteristics. Using data from the **Heart Attack Risk & Prediction Dataset in India**,
we analyze 26 key variables to identify influential risk factors and build predictive models for early
detection and prevention. Among the 26 variables examined, factors such as Age, Alcohol Consumption, LDL
Cholesterol Level, and Emergency Response Time demonstrated notable correlations with heart attack risk.
Our analysis evaluated two predictive models: logistic regression and Random Forest, with the latter
achieving a significantly higher AUC of 0.907, compared to 0.518 for logistic regression. While our
model provides valuable insights for early heart attack risk prediction, incorporating additional
physiological markers, such as inflammatory indicators, could further enhance its predictive power.

The dataset we used covers the diverse conditions of various states in India, it comes from [Heart Attack Risk & Prediction Dataset In India](https://www.kaggle.com/datasets/ankushpanday2/heart-attack-risk-and-prediction-dataset-in-india).

## Report

A detailed analysis of our work can be found [here](https://github.com/DSCI-310-2025/dsci-310-group-15/blob/main/heart-attack-prediction-analysis.ipynb)

## Usage
Use the following steps to reproduce the analysis in a containerized environment:

**1. From your terminal, use the following bash command to clone this repo to your local working directory**
```
git clone https://github.com/DSCI-310-2025/dsci-310-group-15.git
cd dsci-310-group-15
```
**2. Make sure the Docker is running, and then use to following bash command to set up environment**

For Windows users:
```
bash data/script/Wins_setup_analysis.sh
```
For Mac users:
```
bash data/script/Mac_setup_analysis.sh
```

**4. Access the analysis**

Open your browser and go to the website http://localhost:8815

**5. Run the analysis script**

Open heart-attack-prediction-analysis.ipynb in Jupyter to read the annlysis.

## Makefile Command

The Makefile has all the targets needed to render the final Quarto report. The "all" target is to run the entire analysis from top to bottom by running
```
make all
```
Now you can read the analysis in html
```
open reports/heart-attack-prediction-analysis.html
```
and in pdf
```
open reports/heart-attack-prediction-analysis.pdf
```
The "clean" target is to deletes all generate data and files by running 
```
make clean
```

We abstracted some functions from our scripts into the R/ folder with test cases in tests/testthat/.

You can run the tests
```
make test
```

## Dependencies:

R version 4.2.2, Jupyter and
```
- tidyverse (2.0.0)  
- ggplot2 (3.5.1)  
- dplyr (1.1.4)  
- readr (2.1.5)
- broom (1.0.7)  
- GGally (2.2.1)  
- corrplot (0.95)  
- car (3.1-3)  
- glmnet (4.1-8)  
- randomForest (4.7-1.2)  
- caret (7.0-1)  
- pROC (1.18.5)  
- testthat (3.2.3)  
- docopt (0.7.1)  
- repr (1.1.7)  
- IRkernel (1.3.2)  
```

## License Information

This project is under the [MIT open source license](https://opensource.org/licenses/MIT). See [the license file](https://github.com/DSCI-310-2025/dsci-310-group-15/blob/main/LICENSE.md) for more information. 

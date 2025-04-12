# Econ 388 Data Exercise 3—Technological Growth and GDP
This repository contains the data files, Stata code, and analysis for Data Exercise #3 in Dr. Tanner Eastmond's Econ 388 course at Brigham Young University in Winter 2025.
We analyze the relationship between technological advancements and economic growth.

## Data
We use two datasets for the analysis:
1. GDP Per Capita, sourced from [Penn World Table version 10.01](https://www.rug.nl/ggdc/productivity/pwt/), downloaded as a stata file, found in [raw_data/pwt1001.dta](raw_data/pwt1001.dta).
2. Technological progress data, sourced from the [National Bureau of Economic Research (NBER)](https://data.nber.org/data-appendix/w15319/), using the file [raw_data/chat.dta](raw_data/chat.dta.tga).

After cleaning, we saved the cleaned data (with all new generated variables) in [cleaned_data.dta](cleaned_data.dta).

## Analysis
Stata files have been provided for both the cleaning and the statistical analysis.
The cleaning is done in [stata_code/data_cleaning.do](stata_code/data_cleaning.do), while the analysis is done in [stata_code/de3.do](stata_code/de3.do).
Some plotting was done using Python instead, found in [plotting.ipynb](plotting.ipynb).
Log files can be found in [stata_code/data_cleaning.log](stata_code/data_cleaning.log) and [stata_code/DE3.log](stata_code/DE3.log).

## Memo
The write up was done in LaTeX, with the main source code found in [tex_files/data_exercise3.tex](tex_files/data_exercise3.tex).
The completed PDF can be found [here](tex_files/data_exercise3.pdf).
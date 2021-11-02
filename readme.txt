This repository contains the data and code to reproduce the analyses in the manuscript "Decision prioritization and causal reasoning in decision hierarchies" by Ariel Zylberberg.

The main script to run the experiment is: 

"./script_experiment/task_hierarch/main_hierarch.m"

It requires Psychtoolbox for Matlab, and the library 'mpsych' which is included in the repository.

Each block of trials (of 50 trials each) is saved in a seaprate ".mat" file. 
The raw data is included in the folder "./raw_data". 

The raw data are pre-processed with the script "./data/main.m". 
It outputs a file named "alldata.mat" containing all the data used in subsequent analyses. 

To run the figures, first 'cd' to the folder "./analyses_and_models/figures/".  
The file "run_do_figures.m" runs the different figures. It has to be called with a parameter
that indicates which analysis to run. For instance, calling "run_do_figures(1)" reproduces figure 2 of the manuscript. 

To run the different analyses, the folder "matlab_files_addtopath" and its sub-directories have to be added to
the path, e.g. by calling "addpath(genpath('matlab_files_addtopath'))"


Please feel free to contact me with questions. 

- Ariel Zylberberg


 





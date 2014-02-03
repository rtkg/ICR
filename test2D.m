clear all; close all; clc;

options.mu=0.6;
options.disc=60;
options.plot_flag=0;

addpath ./object_generation; 
P = generate_P_ellipse(options.mu,options.disc,options.plot_flag);
rmpath ./object_generation; 






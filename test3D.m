clear all; close all; clc;

options.mu=0.6;
options.disc=60;
options.plot_flag=0;

addpath ./object_generation; 
P = generate_P_ellipse(options.mu,options.disc,options.plot_flag);
G=[21 42 12];
W=[P(G).w]';
 [origin_in_ch,s] = force_closure_test_QR(W);







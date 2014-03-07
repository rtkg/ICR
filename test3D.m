clear all; close all; clc;

options.mu=0.6;
options.disc=60;
options.plot_flag=0;
Qr=0.5;

addpath ./object_generation; 
P = generate_P_ellipse(options.mu,options.disc,options.plot_flag);
G=[21 42 12];
S = computeSearchZones(P,G,Qr);
id=1;
plotSearchZone(S(id),id,2,4);








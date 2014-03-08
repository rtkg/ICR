clear all; close all; clc;

options.mu=0.6;
options.disc=60;
options.plot_flag=0;
alpha=0.5;
nF=3;

gws_col='red';
gws_alpha=0.4;
ews_col='yellow';
ews_alpha=0.8;
psz_col='magenta';
psz_alpha=0.4;

addpath ./object_generation; 
addpath ./plot; 
addpath ./clean_ICR; 
P = generate_P_ellipse(options.mu,options.disc,options.plot_flag);

G=[1 37 25]; %G=randomGrasp(P,nF);
S = computeSearchZones(P,G,alpha);

%plotGraspWrenchSpace(S,gws_col,gws_alpha); hold on;
plotExertableWrenchSpace(S,ews_col,ews_alpha); hold on;
plotPrimitiveSearchZone(S(2).psz(1),1.5,4,psz_col,psz_alpha); hold on;
plotPrimitiveSearchZone(S(2).psz(2),1.5,4,psz_col,psz_alpha); hold on;

icr=computeICR(P,S);
axis equal; rotate3d on;

icr2=invariant_ICR_sphere(G,P,alpha,0,0);





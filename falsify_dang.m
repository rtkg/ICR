clear all; close all; clc;
%e.g G=[34, 33, 42] is invalid for mu/alpha=0.5

addpath ./object_generation; 
addpath ./plot; 
addpath ./clean_ICR; 
addpath ./verification; 

mu=0.5;
disc=60;
alpha=0.5;
nF=3;
options.plot_flag=1;
options.fl_wrench=1;
options.scale_lmbd=1;

P = generate_P_ellipse(mu,disc,options);

while(1)
    G=randomGrasp(P,nF);
    S = computeSearchZones(P,G,alpha);
    icr_dang=computeICRDang(P,S);
    icr=computeICR(P,S);
    
    for i=1:nF
        icr_diff(i).ind=[G(i) setdiff(icr_dang(i).ind, icr(i).ind)];
    end    
    
    %make regions in icr_diff unique for comparison
    for i=2:nF
        I=intersect(icr_diff(i).ind,icr_diff(i-1).ind);
        icr_diff(i).ind=setdiff(icr_diff(i).ind, I);
    end    

    G_inv=gotchaTest(P,S,icr_diff);

    if (~isempty(G_inv))
        break;
    end  
end

for i=1:size(G_inv,1)
    G_test=G_inv(i,:);
    GWS=Polyhedron([P(G_test).w]'); 
    figure;
    plot(GWS,'Color','blue','Alpha',0.4); hold on;
    plotExertableWrenchSpace(S,'yellow',1);
end
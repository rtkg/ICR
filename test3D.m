clear all; close all; clc;

options.mu=0.4;
options.disc=60;
options.plot_flag=0;
alpha=0.32;
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
addpath ./verification; 

P = generate_P_ellipse(options.mu,options.disc,options.plot_flag);

G=[20 44 50 11];%G=[1 37 25]; %G=randomGrasp(P,nF);
S = computeSearchZones(P,G,alpha);

%plotGraspWrenchSpace(S,gws_col,gws_alpha); hold on;
%plotExertableWrenchSpace(S,ews_col,ews_alpha); hold on;
%plotPrimitiveSearchZone(S(1).psz(1),1.5,4,psz_col,psz_alpha); hold on;
%plotPrimitiveSearchZone(S(1).psz(2),1.5,4,psz_col,psz_alpha); hold on;
%plotSearchZoneRoa(S(1),1.5,4,'green',1); hold on;
%plotObjectWrenchSpace(P);

% icr=computeICR(P,S);
% cols{1}=[0 0 1];
% cols{2}=[0 0 1];
% cols{3}=[0 0 1];
% cols{4}=[0 0 1];
% plotICR(icr,P,cols,4);

% icr_roa=computeICRRoa(P,S);
% hold on;
% for n=1:numel(icr_roa)
%     if isempty(icr_roa(n).ind)
%         continue;
%     end    
%    v=[P(icr_roa(n).ind).v]';
%    plot(v(:,1),v(:,2),'rd','MarkerSize',10); 
% end  

icr_dang=computeICRDang(P,S);
% hold on;
% for n=1:numel(icr_dang)
%     if isempty(icr_dang(n).ind)
%         continue;
%     end    
%    v=[P(icr_dang(n).ind).v]';
%    plot(v(:,1),v(:,2),'rd','MarkerSize',10); 
% end  
G_inv=gotchaTest(P,S,icr_dang);


axis equal; rotate3d on;







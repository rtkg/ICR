clear all; close all; clc;
%e.g 
addpath ./third_party;
addpath ./object_generation; 
addpath ./plot; 
addpath ./clean_ICR; 
addpath ./verification; 

mu=0.8;
disc=60;
Qs=0.5;
nF=4;
options.plot_flag=0;
options.fl_wrench=1;
options.scale_lmbd=1;

P = generate_P_ellipse(mu,disc,options);

G_p=[20 11 50 41];
G_t=[27 40 48 5];

v=[P.v]';
plot(v(:,1),v(:,2),'k.'); grid on; hold on; axis equal;
g_p=[P(G_p).v]';
plot(g_p(:,1),g_p(:,2),'go','MarkerSize',6,'MarkerFaceColor','g'); 
g_t=[P(G_t).v]';
plot(g_t(:,1),g_t(:,2),'kd','MarkerSize',10); 

S = computeSearchZones(P,G_p,Qs);

icr=computeICR(P,S);
[icr nb_points]= invariant_ICR_sphere(G_p, P ,Qs, 0,0);
icr_dang=computeICRDang(P,S);
icr_roa=computeICRRoa(P,S);
I=[P([icr.ind]).v]';

I_r=[P([icr_roa.ind]).v]';
I_d=[P([icr_dang.ind]).v]';
plot(I(:,1),I(:,2),'bo','MarkerSize',4,'MarkerFaceColor','b');
plot(I_d(:,1),I_d(:,2),'ro','MarkerSize',10);
if(~isempty(I_r))
    plot(I_r(:,1),I_r(:,2),'ms','MarkerSize',6);
end

return;








while(1)
    G=randomGrasp(P,nF);
    S = computeSearchZones(P,G,Qs);
    icr=computeICR(P,S);
    icr_dang=computeICRDang(P,S);
    icr_roa=computeICRRoa(P,S);
    
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
    GWS_inv=Polyhedron([P(G_test).w]'); 
    
    figure; plotObjectWrenchSpace(P); hold on;
    plotExertableWrenchSpace(S,'yellow',1); hold on; rotate3d on;
    plot(GWS_inv,'Color','blue','Alpha',0.4); hold on;
    for n=1:nF
        for i=1:numel(S(n).psz)
            plotPrimitiveSearchZone(S(n).psz(i),1.2,1,'green',0.8);hold on;
        end
    end
    
    figure; 
    v=[P.v]';
    plot(v(:,1),v(:,2),'k.'); grid on; hold on;
    I=[P([icr.ind]).v]';
    I_r=[P([icr_roa.ind]).v]';
    I_d=[P([icr_dang.ind]).v]';
    
    plot(I(:,1),I(:,2),'bo','MarkerSize',4,'MarkerFaceColor','b');
    plot(I_d(:,1),I_d(:,2),'md','MarkerSize',10);
    if(~isempty(I_r))
        plot(I_r(:,1),I_r(:,2),'gs','MarkerSize',6);
    end
    g=[P(G).v]';
    plot(g(:,1),g(:,2),'ro','MarkerSize',6,'MarkerFaceColor','r'); 
    g_t=1.1*[P(G_test).v]';
    plot(g_t(:,1),g_t(:,2),'mh','MarkerSize',6,'MarkerFaceColor','r'); 
    
    keyboard;
    close all;
end
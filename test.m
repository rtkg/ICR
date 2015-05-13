clear all; close all; clc;
%e.g  G=[ 25     1    36] for fl_wrench=1, mu=Q=0.8
%e.g  G=[29 33 59 3] for fl_wrench=0, mu=Sq=0.8
addpath ./third_party;
addpath ./object_generation; 
addpath ./plot; 
addpath ./clean_ICR; 
addpath ./verification; 

%obj_file = '../../models/parallelepiped.obj';

obj_files{1} = './models/CokePlasticSmall_5k.obj';
obj_files{1} = './models/parallelepiped.obj';
obj_files{2} = './models/Fish_5k.obj';
obj_files{3} = './models/RedCup_5k.obj';
obj_files{4} = './models/ShowerGel_5k.obj';
obj_files{5} = './models/Sprayflask_5k.obj';% G_fail = [400 351 189 2125]
obj_files{6} = './models/Tortoise_5k.obj';

Qs=0.5;
nF=4;
options.grasp_type = 'hf';
options.mu = 0.8;
options.Nc = 8;
options.scale = 1;
options.fl_wrench=1;
options.scale_torque=1;
options.check_all_flag=0;

%P = generate_P(obj_files{1},options);

load P;

        G=randomGrasp(P,nF);
        G=[143        1135         620         929];
        S = computeSearchZones(P,G,Qs);
        icr=computeICR(P,S,G,options);
        icr_dang=computeICRDang(P,S,G,options);
        icr_roa=computeICRRoa(P,S,G,options);

return



for i=1:size(G_inv,1)
    G_test=G_inv(i,:);
    GWS_inv=Polyhedron([P(G_test).w]'); 
    
    figure; plotObjectWrenchSpace(P); hold on;
    plotExertableWrenchSpace(S,'yellow',1); hold on; rotate3d on;
    plot(GWS_inv,'Color','blue','Alpha',0.4); hold on;
    for n=1:nF
        for i=1:numel(S(n).psz)
            %   plotPrimitiveSearchZone(S(n).psz(i),1.2,1,'green',0.8);hold on;
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
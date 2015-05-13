clear all; close all; clc;
%e.g  G=[ 25     1    36] for fl_wrench=1, mu=Q=0.8
%e.g  G=[29 33 59 3] for fl_wrench=0, mu=Sq=0.8
addpath ../../third_party;
addpath ../../object_generation; 
addpath ../../plot; 
addpath ../../clean_ICR; 
addpath ../../verification; 
addpath ../../;

%obj_file = '../../models/parallelepiped.obj';

obj_files{1} = '../../models/CokePlasticSmall_5k.obj';
obj_files{1} = '../../models/parallelepiped.obj';
obj_files{2} = '../../models/Fish_5k.obj';
obj_files{3} = '../../models/RedCup_5k.obj';
obj_files{4} = '../../models/ShowerGel_5k.obj';
obj_files{5} = '../../models/Sprayflask_5k.obj';% G_fail = [400 351 189 2125]
obj_files{6} = '../../models/Tortoise_5k.obj';

Qs=0.5;
nF=4;
options.grasp_type = 'hf';
options.mu = 0.8;
options.Nc = 8;
options.scale = 1;
options.fl_wrench=1;
options.scale_torque=1;
nG = 1;
nO = length(obj_files);
nS = 1000;

% for i=1:nO
%  P{i} = generate_P(obj_files{i},options);
% end
load P;

for i=1:nO
    for j=1:nG
        tic
        G=randomGrasp(P{i},nF);%  143        1135         620         929
        S = computeSearchZones(P{i},G,Qs);
        icr=computeICR(P{i},S);
        icr_dang=computeICRDang(P{i},S);
        icr_roa=computeICRRoa(P{i},S);
        
        icr_diff_c=[];      
        for k=1:nF
            icr_temp = icr_dang;
            for t=1:k
                if t==k
                    icr_temp(t).ind = setdiff(icr_temp(t).ind,icr(t).ind );
                else
                    icr_temp(t).ind = icr(t).ind;
                end    
            end     
            icr_diff_c=[icr_diff_c; allcomb(icr_temp.ind)];
        end    
        
        R{i}{j}.ng_dang=size(allcomb(icr_dang.ind),1);
        R{i}{j}.ng_icr=size(allcomb(icr.ind),1);
        R{i}{j}.e_min=S(1).psz(1).e(1);
        R{i}{j}.G_inv=[];
         R{i}{j}.G_test=[];
        R{i}{j}.de=[];

        % for k=1:nS
        %     ind=randi(size(icr_diff_c,1));
        %     G_test=icr_diff_c(ind,:);
        %     W=[P{i}(G_test).w]';
        %     [origin_in_ch,s] = force_closure_test_QR(W);
        %     if(min(s.b) < R{i}{j}.e_min)
        %         R{i}{j}.G_inv=[R{i}{j}.G_inv; G_test];
        %         R{i}{j}.de=[R{i}{j}.de; (R{i}{j}.e_min-min(s.b))/(R{i}{j}.e_min/100)];
        %     end
        %     R{i}{j}.G_test=[R{i}{j}.G_test; G_test];
        %     icr_diff_c(ind,:)=[];
        %     if isempty(icr_diff_c)
        %         break;
        %     end    

        % end    
        
        for k=1:size(icr_diff_c,1)
            G_test=icr_diff_c(k,:);
            W=[P{i}(G_test).w]';
            [origin_in_ch,s] = force_closure_test_QR(W);
            if(min(s.b) < R{i}{j}.e_min)
                R{i}{j}.G_inv=[R{i}{j}.G_inv; G_test];
                R{i}{j}.de=[R{i}{j}.de; (R{i}{j}.e_min-min(s.b))/(R{i}{j}.e_min/100)];
            end
            R{i}{j}.G_test=[R{i}{j}.G_test; G_test];
        end  
        
        R{i}{j}.ng_test=size(R{i}{j}.G_test,1);
        R{i}{j}.ng_inv=size(R{i}{j}.G_inv,1);
        R{i}{j}.G=G;
        R{i}{j}.icr=icr;
        R{i}{j}.icr_roa=icr_roa;
        R{i}{j}.icr_dang=icr_dang;         
        R{i}{j}.d_time = toc;
        disp(['finished grasp ' num2str(j) ' on object ' num2str(i) ', t: ' num2str(R{i}{j}.d_time) 's']);
        save('R','R');
    end
end



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
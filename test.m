clear all; close all; clc;

OBJ{1}='models/Sprayflask_5k.obj';
OBJ{2}='models/beer_can.obj';
OBJ{3}='models/Shampoo_5k.obj';
OBJ{4}='models/Fish_5k.obj';

options.grasp_type='hf';
options.Nc=8;
options.mu=0.6;
options.scale_torque=true;

addpath ./object_generation;
%addpath /home/rkg/ros/generic/aass_icr/libicr/icrcpp/debug/
%icr=generate_ICRcpp();
%[E,n] = generate_ellipse(1,.5,60,1);
P=generate_P(OBJ{4},options);

plotObject(P,[],0.01); hold on;

% cols{1}=[1 0 0];
% cols{2}=[0 0 1];
% cols{3}=[1 0 1];

 c=mean([P.v]');
 lmbd=0;
 for i=1:length(P)
 if(norm(P(i).v) > lmbd)
     lmbd=norm(P(i).v);
 end    
 end
 
 g_scale=0.1;
 TWS=zeros(6,2); TWS(2,2)=-g_scale;
 TWS(4:6,2)=cross(c,TWS(1:3,2)/lmbd);
 TWS
% plot3(c(1),c(2),c(3),'ro','MarkerFaceColor','r','MarkerSize',12);
%xlabel('x');ylabel('y');zlabel('z');
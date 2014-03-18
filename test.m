clear all; close all; clc;

OBJ{1}='models/Sprayflask_5k.obj';
OBJ{2}='models/beer_can.obj';
OBJ{3}='models/ShowerGel_5k.obj';
OBJ{4}='models/Fish_5k.obj';
OBJ{5}='models/cup.obj';

options.grasp_type='hf';
options.Nc=8;
options.mu=0.6;
options.scale_torque=true;
options.fl_wrench=true;

addpath ./object_generation;
addpath ./third_party;
%addpath /home/rkg/ros/generic/aass_icr/libicr/icrcpp/debug/
%icr=generate_ICRcpp();
%[E,n] = generate_ellipse(1,.5,60,1);
P=generate_P(OBJ{5},options);
plotObject(P,[],[1 1],1e-2);
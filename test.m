clear all; close all; clc;

OBJ{1}='models/Sprayflask_5k.obj';
OBJ{2}='models/beer_can.obj';

options.grasp_type='hf';
options.Nc=8;
options.mu=0.6;
options.scale=1e-3;

addpath ./object_generation;
addpath /home/rkg/ros/generic/aass_icr/libicr/icrcpp/debug/
icr=generate_ICRcpp();
%[E,n] = generate_ellipse(1,.5,60,1);
P=generate_P(OBJ{2},options);

plotObject(P);

cols{1}=[1 0 0];
cols{2}=[0 0 1];
cols{3}=[1 0 1];




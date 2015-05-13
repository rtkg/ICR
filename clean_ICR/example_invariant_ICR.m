clear; close;%clc

plot_flag = 1;
LP_flag = 1;
w_norm_flag = 1;

file_name{1} = './vrml/cup_luigi_centered.wrl';
file_name{2} = './vrml/duck2.wrl';
file_name{3} = './vrml/parallelepiped.wrl';
%file_name{3} = '/home/rkg/Desktop/Tortoise_800.wrl';
%G = [747, 684, 1566, 1267]; %luigis cup centered
G = [ 746  683  1565  1266 ];


grasp_type = 'sf';
mu = 0.6;
discr =8;
alpha = 0.5;
origin_offset = [0;0;0;0;0;0];

P = generate_P_scaled(file_name{1},grasp_type,discr,mu,w_norm_flag);


tic
[icr, nb_points] = invariant_ICR_sphere(G, P ,alpha, LP_flag, plot_flag);
toc


% -------------------------------------------------------------------------
% shift torque origin and recompute
% -------------------------------------------------------------------------
% figure(2);
% 
% origin_offset = [500;0;0;0;0;0];
%  origin_offset = [500;100;200;pi/4;-pi/4;pi/3];
% % origin_offset = [0;0;0;pi/4;-pi/4;pi/3];
% 
% tic
% P_or = change_origin(P,grasp_type,origin_offset);
% [icr_new, N_new] = invariant_ICR_TWS(W_res,G, P_or, origin_offset, LP_flag, plot_flag);
% t(2) = toc;





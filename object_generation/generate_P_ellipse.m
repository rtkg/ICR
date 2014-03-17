function P = generate_P_ellipse(mu,N,options)
%
% generates a structure P containing description of an ellipse
%
% Input:
% ------
% mu - coefficient of friction (if mu == 0 frictionless) (by default mu = 0)
% if plot_flag == 1 plot the ellipse (by default plot_flag = 0)
%
% Output:
% -------
% P - structure containing description of an ellipse
% P(i).v - i-th vertex
% P(i).n - unit normal vector associated with P(i).v
% P(i).nb_i - indexes of the neighboring points of point i
% P(i).n_nb - number of neighboring points of point i
% P(i).w - wrenche(s) associated with point i (depend on grasp_type)
% if P(i).e = 1 the point is explored elseif P(i).e = 0 not explored
%
% 27/01/2010
%

if nargin < 2
    plot_flag = 0;
    fl_wrench=0;
    scale_lmbd=1;
    if nargin < 1
        mu = 0;
    end
else    
    plot_flag = options.plot_flag;
    fl_wrench=options.fl_wrench;
    scale_lmbd=options.scale_lmbd;
end

[pts,vn] = generate_ellipse(2,1,N,plot_flag);

lambda=[];
for i=1:N
    lambda=[lambda norm(pts(:,i))];  
end
if (scale_lmbd)
    P(1).lambda=max(lambda);
else
    P(1).lambda=1;
end

for i=1:N
    P(i).v = [pts(:,i);0]; % point
    P(i).n = [vn(:,i);0]; % normal
    
    % neighbors
    if i == 1
        P(i).nb_i = [N,2];
    elseif i==N
        P(i).nb_i = [N-1,1];
    else
        P(i).nb_i = [i-1,i+1];
    end
    P(i).n_nb = 2;
    
    if mu == 0
        t = cross(P(i).v,P(i).n); % torque
        P(i).w = [P(i).n(1:2);t(3)]; % wrench
    else
        % -----------------------------------
        % generate friction cone in the plane
        % -----------------------------------
        mu_vector = null(P(i).n(1:2)')*mu;
        
        if fl_wrench
            interpN=3;
        else
            interpN=2;
        end
        
        mu_d = linspace(-1,1,interpN);
        for k=1:length(mu_d)
            P(i).cf(:,k) = P(i).n(1:2)+mu_vector*mu_d(k);
            P(i).cf(:,k) = P(i).cf(:,k)/norm(P(i).cf(:,k));
            t(:,k) = cross(P(i).v,[P(i).cf(:,k);0]);
        end    
             
        P(i).w = [P(i).cf;t(3,:)]; % wrenches with the cone forces
    end   
    
    %scale torques if the corresponding flag is set
    if scale_lmbd
       for j=1:size(P(i).w,2)
          P(i).w(3,j)= P(i).w(3,j)/P(1).lambda; 
       end    
    end    
    
    P(i).e = 0; % explored (1) or not (0)
end

%%%EOF

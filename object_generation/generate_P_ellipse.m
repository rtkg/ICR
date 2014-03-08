function P = generate_P_ellipse(mu,disc,plot_flag)
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
    if nargin < 1
        mu = 0;
    end
end

[pts,vn] = generate_ellipse(2,1,disc,plot_flag);
N = size(pts,2);


lambda=[];
for i=1:N
   lambda=[lambda norm(pts(:,i))];  
end
P(1).lambda=max(lambda);


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
       
        if 1 % only testing 
            interpN = 2;
            mu_d = linspace(-1,1,interpN);
            for k=1:length(mu_d)
                P(i).cf(:,k) = P(i).n(1:2)+mu_vector*mu_d(k);
                P(i).cf(:,k) = P(i).cf(:,k)/norm(P(i).cf(:,k));
                t(:,k) = cross(P(i).v,[P(i).cf(:,k);0]);
            end            
        else % this is the real version (equal to the above if interpN=2)
            P(i).cf(:,1) = P(i).n(1:2)+mu_vector;
            P(i).cf(:,2) = P(i).n(1:2)-mu_vector;
            P(i).cf(:,1) = P(i).cf(:,1)/norm(P(i).cf(:,1));
            P(i).cf(:,2) = P(i).cf(:,2)/norm(P(i).cf(:,2));
            t(:,1) = cross(P(i).v,[P(i).cf(:,1);0]);
            t(:,2) = cross(P(i).v,[P(i).cf(:,2);0]);
        end
        
        P(i).w = [P(i).cf;t(3,:)]; % wrenches with the cone forces
        
        % ------------------------------------------------------------
        % testing
        % ------------------------------------------------------------
        tn = cross(P(i).v,P(i).n);
        P(i).wn = [P(i).n(1:2);tn(3)]; % wrench with the normal force
    
        % just to see whether the CH will change (and YES it does)
        %P(i).w = [P(i).w,P(i).wn]; 
        %P(i).w = [P(i).w(:,1),P(i).wn,P(i).w(:,2)];
        % ------------------------------------------------------------
    end
    
    
    P(i).e = 0; % explored (1) or not (0)
end

interpN = size(P(1).w,2);
if plot_flag && mu~=0
    hold on;
    for i=1:N
        for j=1:interpN
            plot([P(i).v(1) P(i).v(1)+P(i).cf(1,j)],[P(i).v(2) P(i).v(2)+P(i).cf(2,j)],'b');
        end
    end
end


if mu
    Nc=2;
else
    Nc=1;
end


    for i=1:N
        for j=1:Nc
            P(i).w(3,j)=P(i).w(3,j)/P(1).lambda;
        end
    end



%%%EOF

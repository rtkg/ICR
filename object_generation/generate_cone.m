function v = generate_cone(n,mu,N,p,plot_flag)
%
% genrates N vectors approximating a friction cone
%
% Input:
% ------
% n - contact normal vector
% mu - friction coefficient
% N - number of vectors for the approximation
% p - point of contact (used only for the visualization)
% if plot_flag == 1 plots the cone
%
% Output:
% -------
% v - vectors approximating a cone (expressed in the world frame and normalized)
%
% Note:
% -----
% the function aa2R.m from the bMSd toolbox is used
%
% 21/01/2010
%

if nargin < 5
    plot_flag = 0;
    if nargin < 4
        p = [0;0;0];
        if nargin < 3
            N = 6;
            if nargin < 2
                mu = 0.4;
            end
        end
    end
end

% make sure that the normal vector is of unit magnitude
n = n/norm(n);

% local z axis
z_ax = [0;0;1];

% height of the cone
h = 1;

% mu is the radius of the circle when the height of the cone is 1
r = mu;

a = linspace(-pi,pi,N+1);
a = a(1:end-1); % exclude the last because it is the same as the first

x = r*cos(a);
y = r*sin(a);
z = zeros(1,N)+h;
v = [x;y;z];

rot_ax = cross(z_ax,n);
rot_an = acos(z_ax'*n); %norm(z_ax) = norm(n) = 1 is assumed

if norm(rot_ax) > 1e-15
    rot_ax = rot_ax/norm(rot_ax);
    R = aa2R(rot_an,rot_ax); 
else
    if abs(rot_an) < 1e-15 
        R = eye(3);
    else % rot_an == pi
        R = rx(pi);
    end
end

v = R*v;
n_test = R*z_ax;

if norm(n-n_test) > 1e-14    
    disp('ERROR')
end

% normalize
for i=1:N
    v(:,i) = v(:,i)/norm(v(:,i));
end

% plot related
% ------------------------------------------------------------------
if plot_flag
    hold on;
    plot3(p(1)+v(1,:),p(2)+v(2,:),p(3)+v(3,:))
    plot3(0,0,0)

    for i=1:N
        plot3([p(1) p(1)+v(1,i)],[p(2) p(2)+v(2,i)],[p(3) p(3)+v(3,i)],'r')
    end
    plot3([p(1) p(1)+n(1)],[p(2) p(2)+n(2)],[p(3) p(3)+n(3)],'k','LineWidth',3)

    xlabel('X');ylabel('Y');zlabel('Z')
    grid on;axis equal
end
% ------------------------------------------------------------------

%%%EOF

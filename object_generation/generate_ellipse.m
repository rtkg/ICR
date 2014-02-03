function [E,n] = generate_ellipse(xa,ya,N,plot_flag)
%
% Generates N points of an ellipse with semi-axes xa and ya
%
% Input:
% ------
% xa - x semi-axis
% ya - y semi-axis
% N - number of points to generate
% if plot_flag == 1 plot the ellipse
%
% Output:
% -------
% E - N points on the ellipse
% n - normal vecotrs associated with each point
%
% Example:
% E = ell_plot(2,1,60);
%

%t=pi*[-1:1/(N/2):1];

% start with [0;-1] (clockwise)
% I know ... looks crazy :)
t=pi*[-0.5:-1/(N/2):-2.5]; 
t = t(1:end-1);

E=[xa*cos(t);ya*sin(t)];
n = normal2ellipse(E(1,:),E(2,:),xa,ya);

if plot_flag
    hold on
    plot(E(1,:),E(2,:),'rs');
    plot(E(1,:),E(2,:),'r');

    % plot the normals outward (for convenience)
    for i=1:size(E,2)
        plot([E(1,i) E(1,i)-n(1,i)],[E(2,i) E(2,i)-n(2,i)],'g')
    end

    grid on
    axis equal
end


function n_out = normal2ellipse(X,Y,a,b)
%
% Generates normals to ellipse at points (X,Y)
% a - x semi axis
% b - y semi axis
%

N = length(X);
x = [-1 1];
n_out= zeros(2,N);

for k = 1:N
    x0 = X(k);
    y0 = Y(k);

    if  abs(y0) > 1e-10
        m = -b^2*x0/(a^2*y0); % slope of the tangent line
        B = y0-m*x0;
        y = m*x+B;

        A = [x(1), y(1);
            x(2), y(2)];

        n = inv(A)*[1;1];
        n = n/norm(n);
    else
        if x0 > 0
            n = [1;0];
        elseif x0 < 0
            n = [-1;0];
        end
    end

    n_out(:,k) = -n; % to point inward
end
%%%EOF (normal2ellipse)

%%%EOF (generate_ellipse)

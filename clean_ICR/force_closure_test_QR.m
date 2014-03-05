function [origin_in_ch,s] = force_closure_test_QR(W)
%
% function that tests whether the convex hull of a given set of points
% contains a neighborhood of the origin. A neighborhood of the origin is
% defined by tolerance 1e-10
%
% Input:
% ------
% W {nPoints \times nDim}- an array of points (each row of W is one point)
% nPoints > nDim, and rank(W) = nDim are assumed
%
% Output:
% -------
% if origin_in_ch == 1 the origin is in the interior of the convex hull
% if origin_in_ch == 0 the origin is NOT in the interior of the convex hull
% if origin_in_ch == -1 convhulln returned an error
%
% s - a structure with the following fields
% s.A, s.b - define the supporting hyperplanes for the convex hull
% s.A - contains the unit normals to each hyperplane
% s.b - contains the distance of each hyperplane to the origin
% if x is a point in the convex hull, then A*x+b >= 0
%
% s.K - indexes of points (from W) that define the supporting hyperplanes
% s.Ku - set of indexes corresponding to vertex points of the convex hull
% s.Ke - set of excluded points from W (i.e. such that are in the interior of the convex hull)
% s.Ka - only the hyperplanes from K included in A and b
% s.C - centroid of the convex hull
% s.nPoints, s.nDim - dimensions of W
%
% Note:
% ------
% If convhulln returns an error, it is stored in s, and origin_in_ch is set
% to -1
%
% 22/01/2001
%

[nPoints,nDim] = size(W);

try
    K = convhulln(W); % compute the convex hull
catch err
    origin_in_ch = -1;
    s = err;
    disp('ERROR: in convhulln (error message suppressed)')
    return
end

% set of indexes corresponding to vertex points of the convex hull
Ku = unique(K);

% set of excluded points from W (i.e. in the polyhedron)
Ke = setdiff(1:nPoints, Ku)'; % Ke is not used in this function

[M,N] = size(K);
C = mean(W(Ku,:)); % centroid
C = C(:);

% initialize A, b and V
A = zeros(M,N);
b = zeros(M,1);
V = zeros(N,N-1);
Ka = zeros(size(K));

rc=0;
for i=1:M
    F = W(K(i,:),:);

    % form N-1 vectors in the plane
    for j=2:N
        V(:,j-1) = F(1,:)' - F(j,:)';
    end

    [Q,R] = qr(V);
    n = Q(:,end)';

    % verify that n is normal to the plane
    if norm(n*V) > 1e-12
        disp('ERROR: in force_closure_test_QR')
        return
    end
  
    if rank(R) >= N-1
        rc=rc+1;

        Ka(rc,:) = K(i,:);
    
        A(rc,:) = n;
        b(rc) = -A(rc,:)*F(1,:)';

        % make sure that the direction of the normals are consistent
        % so that A*C+b >=0 (element-wise).
        tmp = A(rc,:)*C + b(rc);
        if tmp < -1e-15
            A(rc,:) = -A(rc,:);
            b(rc) = -b(rc);
        end
    end
end
A=A(1:rc,:);
b=b(1:rc);
Ka = Ka(1:rc,:);

% % eliminate duplicate constraints (this changes the order of the constraints)
% % I dont linke the fact that we use num2str ... to change
% if 0
%     [null,I]=unique(num2str([A b],6),'rows');
%         
%     I = sort(I);
%     
%     A=A(I,:); % rounding is NOT done for actual returned results
%     b=b(I);
%     Ka = Ka(I);
% end


origin_in_ch = 1;
if min(b) < 1e-10
    origin_in_ch = 0;
end

% form output
s.A = A;
s.b = b;
s.K = K;
s.C = C;
s.Ku = Ku;
s.Ke = Ke;
s.Ka = Ka;
s.nPoints = nPoints;
s.nDim = nDim;
%%%EOF
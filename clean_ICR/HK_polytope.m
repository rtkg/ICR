function s = HK_polytope(W)


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
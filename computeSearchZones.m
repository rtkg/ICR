function S = computeSearchZones(P,G,Qr)
%

% Qr - radius of a spherical task wrench space

K=size(P(1).w,1); %dimension
L=size(P(1).w,2); %wrench cone discretization
nG=length(G);

W=[P(G).w]';
[origin_in_ch,s] = force_closure_test_QR(W);

if (origin_in_ch ~= 1)
  error('Provided grasp is not force closure - cannot compute search zones');
end






% ff contains indexes (in s.Ka) of hyperplanes that contain vertex W(nW_i,:)
[ff,dummy] = find(s.Ka==nW_i);
ff_n = length(ff);

% p contains indexes (in W) of hyperplanes that contain vertex W(nW_i,:)
p = s.Ka(ff,:); 

np1 = size(p,1);
for i=1:np1
    pc(i,:) = mean(W(p(i,:),:));
end
C = mean([pc;W(nW_i,:)])'; % centroid
%hold on;plot3(C(1),C(2),C(3),'ks','MarkerSize',10)

nn = pinv(pc)*ones(np1,1);
nn = nn/norm(nn);

pc_c = sum(pc)/4;
pc_b = -nn'*pc_c';
pl = [nn;pc_b];

A = -s.A(ff,:); % the format used in MPT is different
b = s.b(ff);

Ai = [A;-pl(1:end-1)'];
bi = [b;f*pl(end)];
 
hi = Ai*C - [b;0];
if max(hi)>1e-10
    disp('WARNING: pl: change of sign (see search_regions.m)')
    pl = -pl;
end

if Qr < 0.001 % there is some numerical problem with MPT
    disp('WARNING: b1: set to zero (see search_regions.m)')
    b1 = zeros(ff_n,1);
else
    b1 = zeros(ff_n,1)+Qr;
end

b = b1;

%Ao = [-A;pl(1:end-1)'];
Ao=-A;
bo=-b;
%bo = [-b;-f*pl(end)];

% Ab=[0 -1 0]; bb=abs(ax(3));
% Ab=[Ab;0 1 0 ]; bb=[bb; abs(ax(4))];
% Ab=[Ab;-1 0 0 ]; bb=[bb; abs(ax(1))];
% Ab=[Ab;1 0 0 ]; bb=[bb; abs(ax(2))];
% Ab=[Ab;0 0 -1 ]; bb=[bb; abs(ax(5))];
% Ab=[Ab;0 0 1 ]; bb=[bb; abs(ax(6))];
%    
% box=polytope(Ab,bb);

%n=4;
P=polytope(Ao,bo);
%ints=intersect(polytope(Ao(1:n-1,:),bo(1:n-1)),cyl);
%Options.color='g';
%Options.shade=0.8;
%plot(ints,Options)

%ints=intersect(polytope(Ao(n,:),bo(n)),cyl);
%ints=intersect(polytope(Ao(1:n,:),bo(1:n)),cyl);
%plot(ints,Options)

%tgt=Ao(n,:)*bo(n);
%plot3(tgt(1),tgt(2),tgt(3),'ro','MarkerSize',5,'MarkerFaceColor','r')
P=polytope/intersect(cyl,P);

%plot(P,'r')
%%%EOF

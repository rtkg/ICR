function plotSearchZoneRoa(S,r,h,col,alpha)
%Plots the 3D primivite search sone psz by intersecting it with a cylinder of radius r and height +/-h

if (size(S.psz(1).H,2) ~= 3)
    error('Primitive search zone needs to live in 3D');
end    

tol=1e-4;
%compute a cylinder for the intersection

N=100;
x=cos(linspace(0,2*pi,N))*r;
y=sin(linspace(0,2*pi,N))*r;
z=ones(1,N)*h/2;
C=Polyhedron([x' y' z'; x' y' -z']);
%C.computeHRep(); C.normalize();

H=[]; e=[];
for i=1:length(S.psz)
H=[H; S.psz(i).H];
e=[e; S.psz(i).e];
end    

SZ=Polyhedron(H,-e);
SZ_C=intersect(SZ,C);  %Compute the intersection

for h=1:size(SZ.H,1)
   H=SZ.H(h,1:3); e=SZ.H(h,4);
   %find all vertices lying on the current facet
   V=[];
   for i=1:size(SZ_C.V,1)
       v=SZ_C.V(i,:)';
       if ( abs(H*v-e) < tol)
           V=[V;v'];
       end   
   end  
   plot(Polyhedron(V),'Color',col,'Alpha',alpha); hold on;
end    
hold off;


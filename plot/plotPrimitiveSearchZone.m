function plotPrimitiveSearchZone(psz,r,col,alpha)
%Plots the 3D primivite search sone psz by intersecting it with a sphere of radius r 

if (size(psz.H,2) ~= 3)
    error('Primitive search zone needs to live in 3D');
end    

%compute a cylinder for the intersection
% N=100;
% x=cos(linspace(0,2*pi,N))*r;
% y=sin(linspace(0,2*pi,N))*r;
% z=ones(1,N)*h/2;
% C=Polyhedron([x' y' z'; x' y' -z']);
% %C.computeHRep(); C.normalize();

res=0.25;
phi=-pi:res:pi;
psi=-pi:res:pi;
X=[];
for i=1:length(phi)
    for j=1:length(psi)
     X=[X; r*cos(psi(j))*cos(phi(i))    r*cos(psi(j))*sin(phi(i))   r*sin(psi(j))];  
    end        
end
%plot3(X(:,1),X(:,2), X(:,3),'k.'); axis equal;

C=Polyhedron(X);
PSZ=Polyhedron(psz.H,-psz.e);
PSZ_C=intersect(PSZ,C);  %Compute the intersection
tol=1e-4;
for h=1:size(PSZ.H,1)
   H=PSZ.H(h,1:3); e=PSZ.H(h,4);
   %find all vertices lying on the current facet
   V=[];
   for i=1:size(PSZ_C.V,1)
       v=PSZ_C.V(i,:)';
       if ( abs(H*v-e) < tol)
           V=[V;v'];
       end   
   end  
   plot(Polyhedron(V),'Color',col,'Alpha',alpha); hold on;
end    
hold off;


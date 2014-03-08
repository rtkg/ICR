function plotPrimitiveSearchZone(psz,r,h,col,alpha)
%Plots the primivite search sone psz by intersecting it with a cylinder of radius r and height +/-h

tol=1e-4;
%compute a cylinder for the intersection

N=100;
x=cos(linspace(0,2*pi,N))*r;
y=sin(linspace(0,2*pi,N))*r;
z=ones(1,N)*h/2;
C=Polyhedron([x' y' z'; x' y' -z']);
%C.computeHRep(); C.normalize();

PSZ=Polyhedron(psz.H,-psz.e);
PSZ_C=intersect(PSZ,C);  %Compute the intersection

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
   plot(Polyhedron(V),'Color',col,'Alpha',alpha);
end    



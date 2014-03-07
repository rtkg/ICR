function plotSearchZone(Sz,id,r,h)

%compute a cylinder for the intersection
N=10;

x=cos(linspace(0,2*pi,N))*r;
y=sin(linspace(0,2*pi,N))*r;
z=ones(1,10)*h/2;

C=Polyhedron([x' y' z'; x' y' -z']);
keyboard

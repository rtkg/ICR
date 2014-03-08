function plotExertableWrenchSpace(S,col,alpha)

H=[]; e=[]; W=[];
for i=1:length(S)
    for j=1:length(S(i).psz)
        W=[W; S(i).psz(j).pw'];
        H=[H; S(i).psz(j).H];
        e=[e; S(i).psz(j).e];
    end
end    

EWS=Polyhedron(-H,e);

%GWS=Polyhedron(W); GWS.computeHRep(); GWS.normalize();
%plot3(0,0,0,'k+','MarkerSize',5); hold on;
%plot(GWS,'Alpha',0.4,'Color','red');

plot(EWS,'Color',col,'Alpha',alpha);
%EOF
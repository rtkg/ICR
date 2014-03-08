function plotGraspWrenchSpace(S,col,alpha)

W=[];
for i=1:length(S)
    for j=1:length(S(i).psz)
        W=[W; S(i).psz(j).pw'];
    end
end    

GWS=Polyhedron(W); %%GWS.computeHRep(); GWS.normalize();
plot(GWS,'Alpha',alpha,'Color',col);
%EOF
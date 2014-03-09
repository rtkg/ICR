function plotObject(P,varargin)

FV.faces=P(1).faces;
FV.vertices=P(1).vertices;

col=[0.4 1 0];
%col=[1 .5 0];
if nargin >1
    if ~isempty(varargin{1})
        col=varargin{1};
    end
end

%Plot object
patch(FV,'FaceColor',col,'FaceAlpha',0.5,'EdgeAlpha',0.1); axis equal; rotate3d on;

if nargin <= 2
    return;
end

%Plot normals
scale=varargin{2};
hold on;
for i=1:size(FV.vertices,1);
    p1=FV.vertices(i,:); p2=FV.vertices(i,:)-scale*P(1).normals(i,:);
    plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b-');
end
hold off;
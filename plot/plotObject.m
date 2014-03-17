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

alpha=[0.8 0.2];
if nargin >2
    if ~isempty(varargin{2})
        alpha=varargin{2};
        if(length(alpha)~=2)
           error('Two alpha values (faces & edges) need to be supplied'); 
        end    
    end
end

%Plot object
patch(FV,'FaceColor',col,'FaceAlpha',alpha(1),'EdgeAlpha',alpha(2)); axis equal; rotate3d on;

if nargin <= 3
    return;
end

%Plot normals
scale=varargin{3};
hold on;

for i=1:size(FV.vertices,1);
    p2=FV.vertices(i,:); p1=FV.vertices(i,:)-scale*P(i).n';
    plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'b-');
end
hold off;
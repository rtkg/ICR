clear all; close all; clc;

OBJ{1}='models/Sprayflask_5k.obj';

options.grasp_type='hf';
options.Nc=8;
options.mu=0.6;
options.scale=1e-3;

addpath ./object_generation; 
[E,n] = generate_ellipse(1,.5,60,1);
%P=generate_P(OBJ{1},options);
rmpath ./object_generation; 
return

FV.faces=P(1).faces;
FV.vertices=P(1).vertices;

%Plotting
figure, patch(FV,'FaceColor',[1 0 0]); axis equal; camlight; rotate3d on; hold on;
s=1e-2;
    for i=1:size(FV.vertices,1);
        p1=FV.vertices(i,:); p2=FV.vertices(i,:)-s*P(1).normals(i,:);       
        plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'g-');
    end      





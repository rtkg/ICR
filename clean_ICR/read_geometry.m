function [pts,tri,vn] = read_geometry(path)
%
%path = path to the vrml-file to be read
%origin_offset = [x; y; z; rpy_angles] 
%
%pts  = matrix containing the pointcloud
%tri  = matrix containing the indices of the triangulated 
%       surface patches
%vn   = matrix containing the vertex normals

[nel,w3d,infoline] = read_vrml(path);

w3d=w3d(1,1);
tri=w3d.knx; %indices of the surfaces
pts=w3d.pts;% pointcloud

%he=trisurf(tri,pts(:,1),pts(:,2),pts(:,3),2,'FaceAlpha',0.2,'EdgeAlpha',0.5);
he=trisurf(tri,pts(:,1),pts(:,2),pts(:,3),2,'FaceAlpha',0.2,'LineStyle','none'); %'Visible','off'
%he=trisurf(tri,pts(:,1),pts(:,2),pts(:,3),2);

vn = get(he,'VertexNormals');
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');

%normalizing of the vertex-normals
for i=1:size(vn(:,1))
   vn(i,:)=vn(i,:)/norm(vn(i,:));
end

%close all
hold on;
quiver3(pts(:,1),pts(:,2),pts(:,3),vn(:,1),vn(:,2),vn(:,3),2); 

%EOF


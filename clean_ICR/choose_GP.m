% script for choosing grasp points on an object
%clear
file_name = './vrml/cup_luigi_centered.wrl';
file_name = '/home/rkg/Data/Coding/icrcpp2.0/Data/models/tetrahedron_simple.wrl';
%file_name = './vrml/cup_luigi.wrl';
[pts,tri,vn] = read_geometry(file_name);

fig = figure;
trisurf(tri,pts(:,1),pts(:,2),pts(:,3),2);
hold on;
%plot3(pts(:,1),pts(:,2),pts(:,3),'rs','MarkerSize',10)
axis equal
grid on
datacursormode on

%%%EOF

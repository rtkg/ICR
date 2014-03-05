function [nb_i,n] = get_neighbors(p_i,pts,tri)

%p_i = index of the point for which the neighbors shall be found
%pts  = matrix containing the pointcloud
%tri  = matrix containing the indices of the triangulated 
%       surface patches
%nb_i = indices of the neighboring points
%nb   = coordinates of the neighboring points
%n    = number of neighboring points

%find indices of rows containing the point
[r_nb,dummy]=ind2sub(size(tri),find(tri==p_i));

%store the rows containing indices of neighboring points in nb_i
nb_i=tri(r_nb,:);

%remove multiple index elements
nb_i=unique(nb_i(:));

%remove the point index itself
nb_i=setdiff(nb_i,p_i);

%DD make sure that nb_i is a row vector (used in form_ICR_2.m : s = P(icr(n).ind(icr(n).current)).nb_i)
nb_i = nb_i(:)';

n=length(nb_i);

%extract the coordinates of the neighboring points from the 
%point cloud
%nb=pts(nb_i,:);





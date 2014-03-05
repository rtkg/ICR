function P = generate_P(vrml_file_name,grasp_type,Nc,mu,w_norm_flag)
%
% generates a structure P containing object description
%
% Input:
% ------
% vrml_file_name - name of the vrml file to load (example: './vrml/cone.wrl')
% grasp_type - sf - soft finger point contact
%              hf - hard finger point contact
%              fl - frictionless point contact
% Nc - number of vectors for approximating the friction cone
% mu - friction coefficient
% if w_norm_flag == 1 normalize w
%
% Output:
% -------
% P - structure containing description of the object in vrml_file_name
% P(i).p - i-th point
% P(i).n - unit normal vector associated with P(i).p 
% P(i).nb_i - indexes of the neighboring points of point i
% P(i).NbOfNeighbors - number of neighboring points of point i
% P(i).w - wrenche(s) associated with point i (depend on grasp_type)
% if P(i).e = 1 the point is explored elseif P(i).e = 0 not explored
%
% 27/01/2010
%

if nargin < 5
    w_norm_flag = 0;
end

% read point cloud, mesh and vertex-normals
[pts,tri,vn]=read_geometry(vrml_file_name);
N = size(pts,1);
P(1).tri = tri;
t_max=0;
for i=1:N
    P(i).p = pts(i,:)'; % point
    P(i).n = vn(i,:)'; % normal
    
    [P(i).nb_i,P(i).NbOfNeighbors] = get_neighbors(i,pts,tri);
  
    switch grasp_type
        case 'fl'
            Nc=1;
            
            P(i).w = [P(i).n*10;cross(P(i).p,P(i).n*10)]; % wrench due to the normal force
            
               temp=norm(cross(P(i).p,P(i).n));
                if temp > t_max
                    t_max =temp;
                end
            
        case 'hf'
            P(i).cf = generate_cone(P(i).n,mu,Nc,P(i).p,0)*1; %generation of the cone forces
            for j=1:Nc
                t(:,j)=cross(P(i).p,P(i).cf(:,j)); %generation of the Nc cf-torques
                temp=norm(t(:,j));
                if temp > t_max
                    t_max =temp;
                end
          
            end
            P(i).w = [P(i).cf;t];
            % normalization of the whole wrench
      
        case 'sf'
            P(i).cf = generate_cone(P(i).n,mu,Nc,P(i).p,0); %generation of the cone forces
            for j=1:Nc
                t(:,j)=cross(P(i).p,P(i).cf(:,j)); %generation of the Nc cf-torques
                temp=norm(t(:,j));
                if temp > t_max
                    t_max =temp;
                end
            end
            % finger torques in direction of the vertex-normals
            P(i).w = [[P(i).cf;t] [[zeros(3,1); P(i).n] [zeros(3,1); -P(i).n]]];
            if t_max < 1
                t_max=1;
            end
        otherwise
            error('Unknown grasp type')
    end
    P(i).e = 0; % explored (1) or not (0)
end
P(1).t_max=t_max;
if w_norm_flag
    if grasp_type == 'sf'
        Nc=Nc+2;
    end
    for i=1:N
        for j=1:Nc
            P(i).w(4:6,j)=P(i).w(4:6,j)/t_max;
        end
    end
end

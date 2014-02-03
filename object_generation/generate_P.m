function P = generate_P(obj_file,options)
%
% generates a structure P containing object description
%
% Input:
% ------
% obj_file - path to the .obj file to load (example: './models/Sprayflask_5k.obj')
% options. grasp_type - sf - soft finger point contact
%                       hf - hard finger point contact
%                       fl - frictionless point contact
% options.Nc - number of vectors for approximating the friction cone
% options.mu - friction coefficient
% options.scale - factor with which the loaded vertices are scaled

%
% Output:
% -------
% P - structure containing description of the object in vrml_file_name
% P(i).p - i-th point
% P(i).n - unit normal vector associated with P(i).p 
% P(i).nb_i - indexes of the neighboring points of point i
% P(i).NbOfNeighbors - number of neighboring points of point i
% P(i).w - wrench cone associated with point i (depend on grasp_type)
% if P(i).e = 1 the point is explored elseif P(i).e = 0 not explored
%
% 27/01/2010
%


% read point cloud, mesh and vertex-normals
O=read_wobj(obj_file);
FV.vertices=O.vertices*options.scale;
FV.faces=O.objects(end).data.vertices;
normals=patchnormals(FV);
N = size(FV.vertices,1);

P(1).faces = FV.faces;
P(1).vertices = FV.vertices;
P(1).normals = normals;
t_max=0;
for i=1:N
    P(i).v = FV.vertices(i,:)'; %vertex
    P(i).n = normals(i,:)'; % normal
    
    [P(i).nb_i,P(i).NbOfNeighbors] = get_neighbors(i,FV.vertices,FV.faces);

    switch options.grasp_type
        case 'fl'
            options.Nc=1;
            P(i).w = [P(i).n;cross(P(i).v,P(i).n)]; % wrench due to the normal force
            
               temp=norm(cross(P(i).v,P(i).n));
                if temp > t_max
                    t_max =temp;
                end
            
        case 'hf'
            P(i).cf = generate_cone(P(i).n,options.mu,options.Nc,P(i).v,0); %generation of the cone forces
            for j=1:options.Nc
                t(:,j)=cross(P(i).v,P(i).cf(:,j)); %generation of the Nc cf-torques
                temp=norm(t(:,j));
                if temp > t_max
                    t_max =temp;
                end
          
            end
            P(i).w = [P(i).cf;t];
      
      
        case 'sf'
            P(i).cf = generate_cone(P(i).n,options.mu,options.Nc,P(i).v,0); %generation of the cone forces
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
    if options.grasp_type == 'sf'
        options.Nc=options.Nc+2;
    end
    for i=1:N
        for j=1:options.Nc
            P(i).w(4:6,j)=P(i).w(4:6,j)/t_max;
        end
    end

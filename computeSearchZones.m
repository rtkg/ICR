function S = computeSearchZones(P,G,Qr)
%

% Qr - scaling factor for the OCIS of the prototype grasp's GWS in order to
% model the TWS

K=size(P(1).w,1); %dimension
L=size(P(1).w,2); %wrench cone discretization
nF=length(G);

W=[P(G).w]';
[origin_in_ch,s] = force_closure_test_QR(W);

if (origin_in_ch ~= 1)
    error('Provided grasp is not force closure - cannot compute search zones');
end

for n=1:nF
    map_vertex2finger(n)=n*L;
end    

H=size(s.Ka,1);
v_ids=unique(s.Ka);
S(nF).psz=[];
for v=1:length(v_ids) %iterates throug the vertex indices of the GWS
    % find finger associated with v
    for n=1:nF
        if (v_ids(v) <= map_vertex2finger(n))
            f_id=n;
            break;
        end    
    end      
    %initialize new empty primitive search zone for v
    if isempty(S(f_id).psz)
        psz.H=[];
        S(f_id).psz=psz;
    else
    S(f_id).psz(end+1).H=[];    
    end    
    S(f_id).psz(end).e=[];
    S(f_id).psz(end).pw=W(v_ids(v),:)';
    
    %find the facets corresponding to v_ids(v), shift them and add them to the
    %newly created primitive search zone
    for h=1:H
        facet=s.Ka(h,:);
        if ~isempty(intersect(facet,v_ids(v)))
            %add facet h to the primitive search zone assoicated with wrench
            %v_ids(v)
            S(f_id).psz(end).H=[S(f_id).psz(end).H; s.A(h,:)];
            S(f_id).psz(end).e=[S(f_id).psz(end).e; s.b(h)];
        end        
    end
end


%EOF

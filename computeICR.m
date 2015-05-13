function icr=computeICR(P,S,G,options)
%Fill the search regions with primitive-wrench best inclusion test checks
assert(length(S)==length(G));

nF=length(S);
nP=length(P);

icr(nF).ind=[];
for n=1:nF
    queue = G(n);
    explored = zeros(nP,1);
    while ~isempty(queue)
        inclusion_test=true;
        
        %FIND INDEX HERE
        id=queue(1);
        queue(1)=[]; %pop front
        if (explored(id) == 1)
            continue; %if the current point is explored, try the next one
        else
            explored(id) = 1; %set the current point as explored  
        end    
        
        w=P(id).w;
        nW=size(P(id).w,2);
        
        for i=1:length(S(n).psz)
            H=S(n).psz(i).H; 
            e=S(n).psz(i).e; 
            nH=size(H,1);       
            
            %if none of the primitive wrenches lies inside the current primitive search zone, the
            %point doesn't qulify for inclusion into region n 
            if(min(max(H*w+repmat(e,1,nW))) > 0)
                inclusion_test=false;
                break;
            end                       
        end    
        
        %test the current point and enqueue its neighbors if succesful or the check all flag is set
        if (inclusion_test)
            icr(n).ind=[icr(n).ind id]; 
            queue=[queue; P(id).nb_i'];
        elseif options.check_all_flag
            queue=[queue; P(id).nb_i'];
        end
        
    end    
    icr(n).N=length(icr(n).ind);
end
%EOF


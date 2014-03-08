function icr=computeICR(P,S)
%Fill the search regions with primitive-wrench best inclusion test checks

nF=length(S);
nP=length(P);

icr(nF).ind=[];
for n=1:nF
    for j=1:nP
        inclusion_test=true;
        w=P(j).w;
        nW=size(P(j).w,2);
        
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
        
        if (inclusion_test)
            icr(n).ind=[icr(n).ind j];      
        end
        
    end    
    icr(n).N=length(icr(n).ind);
end
%EOF


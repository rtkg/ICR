function icr=computeICRRoa(P,S)
%Fill the search regions with primitive-wrench best inclusion test checks

nF=length(S);
nP=length(P);

icr(nF).ind=[];
for n=1:nF
    for j=1:nP
        inclusion_test=true;
        w=P(j).w;
        nW=size(P(j).w,2);
        
        %concatenate all primitive search zones -> intersection
        H=[]; e=[];
        for i=1:length(S(n).psz)
            H=[H; S(n).psz(i).H]; 
            e=[e;S(n).psz(i).e]; 
        end    
        
        %if none of the primitive wrenches lies inside the intersection of primitive search zones, the
        %point doesn't qualify for inclusion into region n 
        if(min(max(H*w+repmat(e,1,nW))) < 0)
            icr(n).ind=[icr(n).ind j];  
            keyboard
        end        
    end    
    icr(n).N=length(icr(n).ind);    
end    

%EOF


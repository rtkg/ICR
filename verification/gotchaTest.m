function inv_G=gotchaTest(P,S,icr)


H=[]; e=[]; W=[];
for i=1:length(S)
    for j=1:length(S(i).psz)
        %    W=[W; S(i).psz(j).pw'];
        H=[H; S(i).psz(j).H];
        e=[e; S(i).psz(j).e];
    end
end   
EWS=Polyhedron(-H,e);
V_EWS=EWS.V';
nV_EWS=size(V_EWS,2);

comb=allcomb(icr.ind);
nc=size(comb,1);

inv_G=[];
count=0;
for i=1:nc    
    G=comb(i,:);
    %skip in case two ore more regions contain the same point
    if (length(unique(G)) < length(G))
       continue;
    end   
       
    W=[P(comb(i,:)).w]';
    try
        [o s]=force_closure_test_QR(W);
    catch
        message='Caught Qhull-exception, skipping...';
        disp(message);
        continue;        
    end

   GWS=Polyhedron(W);
   if (~GWS.contains(EWS))
       inv_G=[inv_G; comb(i,:)];
       save('inv_G','inv_G');
   end    
       
    count=count+1;
    
    if ~mod(count,100)
        message=strcat('Remaining iterations:',{' '},num2str(nc-count));
        disp(message);
    end
end
message=strcat(num2str(size(inv_G,1)),{' '},'invalid grasps found');
disp(message);



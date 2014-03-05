function G = randomGrasp(P,K)

pts=[P(1:end).v]';
G=[];
while (isempty(G))
    ran=[];
    % generation of K random contact point indices
    while numel(unique(ran))~=K
        ran = ceil(length(P)*rand(K,1));
    end
    ran=ran';
    W=[P(ran).w]';
    [origin_in_ch,s]=force_closure_test_QR(W);
    
    if origin_in_ch == 1
        G=ran;
        
        %         trisurf([P.tri],pts(:,1),pts(:,2),pts(:,3),2,'FaceAlpha',0.8,'EdgeAlpha',0.5);
        %         hold on
        %         PG=[P(ran).p]';
        %         plot3(PG(:,1),PG(:,2),PG(:,3),'rs');
        %         axis equal;
        %         rotate3d on;
        %         keyboard
        %         close
    end
end


%%%EOF

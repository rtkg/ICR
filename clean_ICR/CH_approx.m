function [CHapp,indices, Wres]=CH_approx(W,k)

%k..... numbers of iterations
%W..... point cloud to approximate

%CHapp.... vectors of the approximated CH
%CHapp.... indicies of CHapp in W
%Wres..... vectors which are outside of CHapp

tol=1e-6;
Wres=[];
[N Dim]=size(W);


%generate 2*Dim start search regions directions created by
%pca give slightly better results
CovW = cov(W);
[Q,L] = eig(CovW);
B = W*Q;
[maxB ind_maxB]=max(B);
[minB ind_minB]=min(B);
ind = [ind_maxB ind_minB];

[maxB ind_maxB]=max(W);
[minB ind_minB]=min(W);
ind = [ind_maxB ind_minB];

CHapp=W(ind,:);
indices=ind; 

for i=1:k    
    %basically the same function as force_closure_test_QR, just needed to
    %get a HK representation of CHapp. it is actually not necessary to
    %create the complete convex hull in each iteration, but just extend it
    s=HK_polytope(CHapp); 

    %search for vectors with the biggest projecton for the given search
    %direction. search directions are normal vectors of the facets of CHapp
    proj=W*-s.A'; 
    [max_dist ind]=max(proj);
    
    %new points have to be 'outside' the facet
    max_dist=max_dist-s.b'; 
    ind=ind(find(max_dist > tol));
  
    indices=[indices ind];
    
    %add the new points 
    CHapp=[CHapp; W(ind,:)];
end


%Uncomment to return Vectors which are outside of the
%approximated CH

%     red=[];
%     for i=1:N
%         if min(s.A*W(i,:)'+s.b) >= -tol
%             red=[red i];
%         end
%     end
%     
%     Wres=W(setdiff(1:N,red),:);

    




function AmsB = minkowski_sum(A,B)
%
% Miknowski sum of sets A and B
% mA - number of elements in A (nA - dimension of each element - vector)
%

[mA,nA] = size(A);
[mB,nB] = size(B);
A=[A;zeros(1,nA)];
B=[B;zeros(1,nB)];
mA=mA+1;
mB=mB+1;

if nA ~= nB
    disp('ERROR: The dimensions of A and B should be the same')
    AmsB = [];
    return
end

k = 0;
AmsB = zeros(mA*mB,nA);
for i = 1:mA
    for j = 1:mB
        k = k+1;
        AmsB(k,:) = A(i,:)+B(j,:);
    end
end

%%%EOF
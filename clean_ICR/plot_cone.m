function plot_cone(P,G)
%
% plots the linear approximation of a friction cone
% for grasp points specified in G.
%
% G is a vector with N point indexes
% the point information is stored in P
% P is assumed to be as generated in generate_P.m
%
% 01/02/2010
%

N = length(G);
Nw = size(P(1).w,2);

hold on;
for k=1:N
    plot3(P(G(k)).p(1)+P(G(k)).w(1,:),P(G(k)).p(2)+P(G(k)).w(2,:),P(G(k)).p(3)+P(G(k)).w(3,:))
    for i=1:Nw
        plot3([P(G(k)).p(1) P(G(k)).p(1)+P(G(k)).w(1,i)],[P(G(k)).p(2) P(G(k)).p(2)+P(G(k)).w(2,i)],[P(G(k)).p(3) P(G(k)).p(3)+P(G(k)).w(3,i)],'r')
    end
    plot3([P(G(k)).p(1) P(G(k)).p(1)+P(G(k)).n(1)],[P(G(k)).p(2) P(G(k)).p(2)+P(G(k)).n(2)],[P(G(k)).p(3) P(G(k)).p(3)+P(G(k)).n(3)],'k','LineWidth',3)
end

%%%EOF
function pickGrasp(P)

FV.faces=P(1).faces;
FV.vertices=P(1).vertices;

patch(FV,'FaceColor','g','FaceAlpha',1,'EdgeAlpha',0); axis equal; rotate3d on; hold on;
v=[P.v]';
plot3(v(:,1),v(:,2),v(:,3),'ro'); hold off;
xlabel('x'); ylabel('y'); zlabel('z'); axis equal;





%%%EOF

function plotObjectWrenchSpace(P)

if (size(P(1).w(:,1),1)~=3)
    error('Object wrench space needs to live in 3D');
end    

plot3(0,0,0,'k+','MarkerSize',10); hold on;
for i=1:length(P)
   plot3(P(i).w(1,:),P(i).w(2,:),P(i).w(3,:),'ko','MarkerSize',8,'MarkerFaceColor','k');
      plot3(P(i).w(1,:),P(i).w(2,:),P(i).w(3,:),'-','Color',[100 100 100]/255,'LineWidth',1);
end    
grid on; hold off;

%EOF
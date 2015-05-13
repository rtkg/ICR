function plotICR(icr,P,cols,varargin)

if (numel(icr) ~= numel(cols))
    error('Need to assign one color for each region!');
end    
scale=1;
if nargin >3
    scale=varargin{1};
end

hold on;
for n=1:numel(icr)
   v=[P(icr(n).ind).v]';
   plot3(v(:,1),v(:,2),v(:,3),'o','Color',cols{n},'MarkerSize',scale,'MarkerFaceColor',cols{n}); 
end    
 
hold off;
%EOF
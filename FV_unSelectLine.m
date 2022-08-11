function FV_unSelectLine

h = findobj(gca,'Type','Line');
set(h,'Selected','off','LineWidth',0.5,'MarkerSize',6);
% set(gco,'Selected','on','LineWidth',1.5,'MarkerSize',6);
FV_selectCurrentPlot;
function FV_selectCurrentPlot

h = findobj('Tag','FVPlot');
set(h,'Selected','off');
set(gcf,'Selected','on');
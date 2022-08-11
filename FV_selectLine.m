function FV_selectLine

FV_unSelectLine; % FV_selectCurrentPlot is also called inside FV_unSelectLine
%     FV_selectCurrentPlot;
set(gco,'Selected','on','LineWidth',1.5,'MarkerSize',6);

t0 = clock;
currentAxes = gco;
UserData = get(currentAxes,'UserData');
if isfield(UserData,'timeLastClick') && etime(t0,UserData.timeLastClick) < 0.4
    point1 = get(gca,'CurrentPoint');
    point1 = point1(1,1:2);
    xdata = get(currentAxes,'XData');
    ydata = get(currentAxes,'YData');
    deltaX = abs(xdata-point1(1));
    [x,I] = min(deltaX);
    dist1 = h_calcDistance(point1,[xdata(I),ydata(I)]);
    if I > 1
        dist2 = h_calcDistance(point1,[xdata(I-1),ydata(I-1)]);
    else
        dist2 = Inf;
    end
    if I < length(xdata)
        dist3 = h_calcDistance(point1,[xdata(I+1),ydata(I+1)]);
    else
        dist3 = Inf;
    end
    if dist2>3*dist1 && dist3>3*dist1
        fname = fullfile(UserData.activeGroup.groupPath,UserData.activeGroup.groupFiles(I).relativePath,...
            UserData.activeGroup.groupFiles(I).fname);
        if exist(fname, 'file')
            fileInfo = h_dir(fname);%h_dir always give full path.
            FV_openFile(guihandles(UserData.parentGUIFigureHandle), fileInfo.name);
        else
            FV_openFile(guihandles(UserData.parentGUIFigureHandle), UserData.activeGroup.groupFiles(I).name);
        end
    end
end
UserData.timeLastClick = t0;
set(currentAxes,'UserData',UserData);
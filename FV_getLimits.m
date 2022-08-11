function [xlim,ylim,zlim] = FV_getLimits(handles)

% global currentStruct;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if isfield(currentStruct.info.scanHeader.acq, 'linescan') && currentStruct.info.scanHeader.acq.linescan 
    %if line scan, using image size as limit otherwise 32X1024 will show as a thin line
    % note that Scanimage 3.8 do not have linescan field. need to check out
    % what is the indicator.
    
    
    xlim = [0,currentStruct.info.size(2)] + 0.5;
    ylim = [0,currentStruct.info.size(3)] + 0.5;
    zlim = [1,size(currentStruct.image.intensity,3)];
    
else
    
    siz = size(currentStruct.image.intensity);
    if length(siz)<3
        siz(3) = 1;
    end
    
    dispAxes = get(handles.viewingAxis,'Value');
    switch dispAxes
        case {1, 4, 7, 10}
            viewingAxis = 3;
        case {2, 5, 8, 11}
            viewingAxis = 1;
        case {3, 6, 9, 12}
            viewingAxis = 2;
    end
    
    zlim = [1, siz(viewingAxis)];
    
    axesRatioStr = get(handles.XYRatio,'String');
    axesRatioStr(strfind(axesRatioStr,':')) = '/';
    axesRatio = eval(axesRatioStr);
    dispAxes2 = [3,1,2];
    dispAxes2(dispAxes2==viewingAxis) = [];
    if round(siz(dispAxes2(2))*axesRatio)>=siz(dispAxes2(1))
        xlim = [0,siz(dispAxes2(2))] + 0.5;
        ysiz = round(diff(xlim)*axesRatio);
        ylim = [0,ysiz] + 0.5 - round((ysiz-siz(dispAxes2(1)))/2);
    else
        ylim = [0,siz(dispAxes2(1))] + 0.5;
        xsiz = round(diff(ylim)/axesRatio);
        xlim = [0,xsiz] + 0.5 - round((xsiz-siz(dispAxes2(2)))/2);
    end
end
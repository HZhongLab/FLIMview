function FV_autoSetAxesRatio(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

header = currentStruct.info.scanHeader;
dispAxes = get(handles.viewingAxis,'Value');

% if exist('calculateFieldOfView', 'file')
    try
        zoom = header.acq.zoomhundreds*100 + header.acq.zoomtens*10 + header.acq.zoomones;
    catch
        zoom = header.acq.zoomFactor;
    end

    try
        [XFieldOfView, YFieldOfView] = calculateFieldOfView(zoom);
    catch
        XFieldOfView = 320/zoom;
        YFieldOfView = XFieldOfView;
    end
    xPixelLength = XFieldOfView/header.acq.pixelsPerLine;
    yPixelLength = YFieldOfView/header.acq.linesPerFrame;
    
    switch dispAxes
        case {1, 4, 7, 10}
            viewingAxis = 3;
            str = '1:1';
        case {2, 5, 8, 11}
            viewingAxis = 1;
            ratio = round(abs(header.acq.zStepSize) / xPixelLength *10)/10;
            str = ['1:',num2str(ratio)];
        case {3, 6, 9, 12}
            viewingAxis = 2;
            ratio = round(abs(header.acq.zStepSize) / yPixelLength *10)/10;
            str = ['1:',num2str(ratio)];
    end 
% else %if not scanimage files and no x, y, z pixel sizes
%     switch dispAxes
%         case {1, 4}
%             viewingAxis = 3;
%             str = '1:1';
%         case {2, 5}
%             viewingAxis = 1;
%             str = '1:10';
%         case {3, 6}
%             viewingAxis = 2;
%             str = '1:10';
%     end
% end

set(handles.XYRatio,'String',str);

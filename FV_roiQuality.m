function FV_roiQuality(handles)

% [currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

ROIObj = findobj(handles.FLIMview,'Tag','FV_ROI');
ROEObj = findobj(handles.FLIMview, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.FLIMview,'Tag','FV_BGROI');

allROIObj = vertcat(ROIObj, ROEObj, bgROIObj);

for i = 1:length(allROIObj)
    parentobj = get(allROIObj(i),'Parent');
    if strcmp(get(parentobj,'Type'),'axes')
        imgobj = findobj(parentobj,'Type','image');
        img = get(imgobj,'CData');
        siz = size(img);
        UserData = get(allROIObj(i),'UserData');
        RoiRect = [min(UserData.roi.xi),min(UserData.roi.yi),...
                max(UserData.roi.xi)-min(UserData.roi.xi),max(UserData.roi.yi)-min(UserData.roi.yi)];
        pos = RoiRect;
        if pos(1)+pos(3)>siz(2)+0.5
            pos(1) = siz(2)+0.5-pos(3);
        end
        if pos(1)<0.5
            pos(1) = 0.5;
        end
        if pos(2)+pos(4)>siz(1)+0.5
            pos(2) = siz(1)+0.5-pos(4);
        end
        if pos(2) < 0.5
            pos(2) = 0.5;
        end
        UserData.roi.xi = UserData.roi.xi - RoiRect(1) + pos(1);
        UserData.roi.yi = UserData.roi.yi - RoiRect(2) + pos(2);
        set(allROIObj(i),'XData',UserData.roi.xi,'YData',UserData.roi.yi,'UserData',UserData);
        set(UserData.texthandle, 'Position', [pos(1)+pos(3)/2,pos(2)+pos(4)/2],'UserData',UserData);
    end
end

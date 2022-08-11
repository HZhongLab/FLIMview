function FV_restoreROIPos(handles)

% global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

UserData = currentStruct.internal.previousROIUserData;

% note: just move things back here. Another way is to delete all current
% ones and replot. The second way may be more widely applicable for
% recovering an accidental delete, etc. Will look into it later.
for i = 1:length(UserData)
    x = (max(UserData(i).roi.xi) + min(UserData(i).roi.xi))/2;
    y = (max(UserData(i).roi.yi) + min(UserData(i).roi.yi))/2;
    set(UserData(i).ROIhandle,'XData',UserData(i).roi.xi,'YData',UserData(i).roi.yi,'UserData',UserData(i));
    set(UserData(i).texthandle, 'Position', [x,y],'UserData',UserData(i));
    
    UserData2 = get(UserData(i).mirrorROIhandle, 'UserData');
    UserData2.roi = UserData(i).roi;
    set(UserData2.ROIhandle,'XData',UserData2.roi.xi,'YData',UserData2.roi.yi,'UserData',UserData2);
    set(UserData2.texthandle, 'Position', [x,y],'UserData',UserData2);
end


function FV_dragROIText

UserData = get(gco,'UserData');
set(gcf,'CurrentObject',UserData.ROIhandle);
FV_dragROI;
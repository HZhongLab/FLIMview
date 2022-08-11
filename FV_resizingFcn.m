function FV_resizingFcn(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);


defaultWidth = 950;
defaultHeight = 550;

ratio = defaultWidth/defaultHeight;
pos = get(handles.FLIMview, 'position');
pos(4) = pos(3)/ratio;
set(handles.FLIMview, 'position', pos);

handleFields = fieldnames(handles);
fontSize = 8/defaultWidth*pos(3);
exceptionListStr = exceptionList;
for i = 1:length(handleFields)
    if ~any(ismember(lower(handleFields{i}), lower(exceptionListStr)))%Haining a quick fix try not to change ROI labeling, but some icons has ROI in it too...
        try, set(handles.(handleFields{i}), 'fontsize', fontSize);end%some properties do not have "fontsize" property.
    end
end

function listStr = exceptionList % the current list is from h_imstack3. Will add for FLIMview as needed.

listStr = { 'refROIText3';
            'scoringROI3text';
            'h_tracingMarkText3'
          };
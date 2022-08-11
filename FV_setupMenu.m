function FV_setupMenu(handles, flag)

global FV_img

if ~exist('flag', 'var') || isempty(flag)
    flag = 'upper';
end

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

% note: set all menu in pixels width 260 and height 200.

if strcmpi(flag, 'upper')
    area_width = 260/950;
    area_height = 4/11; %200/550
    area_x = (950-260)/950;
    area_y = 4/11;
    value = get(handles.higherMenuOpt,'Value');
    if value ~= get(handles.lowerMenuOpt,'Value');% upper and lower Menu cannot have the same value.
        currentStruct.state.higherMenuOpt.value = value;
        if isfield(currentStruct.gh,'upperMenuObj') && ~isempty(currentStruct.gh.upperMenuObj)
            delete(currentStruct.gh.upperMenuObj);
            currentStruct.gh.upperMenuObj = [];
        end
    else
        return;
    end
elseif strcmpi(flag, 'lower')
    area_width = 260/950;
    area_height = 4/11;
    area_x = (950-260)/950;
    area_y = 0;
    value = get(handles.lowerMenuOpt,'Value');
    if value ~= get(handles.higherMenuOpt,'Value');% upper and lower Menu cannot have the same value.
        currentStruct.state.lowerMenuOpt.value = value;
        if isfield(currentStruct.gh,'lowerMenuObj')&& ~isempty(currentStruct.gh.lowerMenuObj)
            delete(currentStruct.gh.lowerMenuObj);
            currentStruct.gh.lowerMenuObj = [];            
        end
    else
        return;
    end
else
    return;
end

h = [];
switch value
    case 1
        h = FV_roiControlGUI;
    case 2
        h = FV_groupControlGUI;
    case 3
        h = FV_frameAnalysisGUI;
    case 4
        h = FV_lifetimeFittingGUI;
    case 5
        h = FV_animalStateTrackerGUI;
    case 6
        h = FV_movieMakerGUI;
    case 7
        h = FV_miscGUI;
    otherwise
end

set(h,'Visible','off');



obj = get(h,'Children');
set(obj,'Units','normalized','Visible','off');
C = h_copyobj(obj,handles.FLIMview);
for i = 1:length(C)
    pos = get(C(i),'Position');
    pos(1) = area_x + area_width*pos(1);
    pos(2) = area_y + area_height*pos(2);
    pos(3) = area_width*pos(3);
    pos(4) = area_height*pos(4);
    set(C(i),'Position',pos);
end
set(C,'Visible','on');
if strcmpi(flag, 'upper')
    currentStruct.gh.upperMenuObj = C;
elseif strcmpi(flag, 'lower')
    currentStruct.gh.lowerMenuObj = C;
end

delete(h);

currentStruct.gh.currentHandles = guihandles(handles.FLIMview);
FV_img.(currentStructName) = currentStruct;
FV_setParaAccordingToState(currentStruct.gh.currentHandles);
FV_updateInfo(handles);

% if value==13
%     h_fileTypeQuality3(handles);
%     h_selectCurrentAnnotationROI3(handles);
% end

FV_resizingFcn(handles);


function C = h_copyobj(varargin)

% this is to detect the Mablab version and for 2014b and later, use
% copyobj(..., 'legacy'). This way, callback properties are also copied in
% the newer versions.

ver = version;
I = strfind(ver, '.');
verNum = eval(ver(1:I(2)-1)); % handle this way because Matlab will soon become verions 10 and the digit increase

if verNum<=8.3 %2014a is version 8.3
    C = copyobj(varargin{:});
else
    C = copyobj(varargin{:}, 'legacy');
end
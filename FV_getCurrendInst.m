function [currentInd, currentHandles, currentStruct, currentStructName] = FV_getCurrendInst(handles)

global FV_img;

if ~exist('handles', 'var') || isempty(handles)
    handles = guihandles(gcf);
end

UData = get(handles.FLIMview,'UserData');
currentInd = UData.instanceInd;

if ~strcmp(get(handles.FLIMview,'Name'), ['FLIMview Instance ',num2str(currentInd)])
    error('index and window name do not match!');
end

currentStructName = ['Inst', num2str(currentInd)];
currentHandles = FV_img.(currentStructName).gh.currentHandles;
currentStruct = FV_img.(currentStructName);



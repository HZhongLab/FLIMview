function FV_setParaAccordingToState(handles, inclusionList, exclusionList)

% global FV_img;



[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;

% inclusionList is a cell str containing the fields want to set. 
% this is better than exclusionList as there are always newly added fields.
if ~exist('inclusionList', 'var') || isempty(inclusionList)
    inclusionList = fieldnames(state); % if it is empty, include everything
elseif ~iscell(inclusionList)
        inclusionList = {inclusionList};
end

% probably should do both inclusionList and exclusionList
if ~exist('exclusionList', 'var') || isempty(exclusionList)
    exclusionList = {''}; % if it is empty, include everything
elseif ~iscell(exclusionList)
        exclusionList = {exclusionList};
end

names = fieldnames(state);
names = names(ismember(names, inclusionList));
names = names(~ismember(names, exclusionList));

for i = 1:length(names)
    try
        ptynames = fieldnames(eval(['state.',names{i}]));
        handlename = ['handles.',names{i}];
        for j = 1:length(ptynames)
            varname = ['state.',names{i},'.',ptynames{j}];
            set(eval(handlename),ptynames{j},eval(varname));
        end
    end
end


    

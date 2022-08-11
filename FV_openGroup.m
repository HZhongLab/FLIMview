function FV_openGroup(handles, filename)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

[pname, fname, fExt] = fileparts(filename);

if isempty(pname)
    pname = pwd;
end

% try
    if exist(filename, 'file')
        load(filename,'-mat');
        FV_img.(currentStructName).activeGroup.groupName = [fname, fExt];
        FV_img.(currentStructName).activeGroup.groupPath = pname;
        FV_img.(currentStructName).activeGroup.groupFiles = groupFiles;
%         h_updateInfo3(handles);% it will run later.
    else
        disp([filename,' not exist!']);
    end
% end

FV_updateInfo(handles);

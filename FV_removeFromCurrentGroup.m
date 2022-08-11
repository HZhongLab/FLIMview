function FV_removeFromCurrentGroup(handles, filename)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

[pname,fname,fExt] = fileparts(filename);

groupFileNames = {currentStruct.activeGroup.groupFiles.fname};
I = ismember(groupFileNames, [fname, fExt]);

if any(I)
    FV_img.(currentStructName).activeGroup.groupFiles(I) = [];
    groupFiles = FV_img.(currentStructName).activeGroup.groupFiles;
    save(fullfile(FV_img.(currentStructName).activeGroup.groupPath,FV_img.(currentStructName).activeGroup.groupName),...
        'groupFiles');
end

FV_updateInfo(handles);




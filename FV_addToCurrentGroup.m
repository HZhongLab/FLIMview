function FV_addToCurrentGroup(handles, filename)

% filename can be a single string or a string cell with many filenames.

global FV_img;

if ~iscell(filename) % this way so that it can handle many filenames at a time.
    filename = {filename};
end

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if isfield(FV_img.(currentStructName),'activeGroup') && ~isempty( FV_img.(currentStructName).activeGroup)
    for i = 1:length(filename)
        currentGroupFile = h_dir(filename{i});
        [currentGroupFile.path, fname, fExt] = fileparts(currentGroupFile.name);
        currentGroupFile.fname = [fname, fExt];
        currentGroupFile.relativePath = h_getRelativePath(currentStruct.activeGroup.groupPath, currentGroupFile.path);
        if isempty(FV_img.(currentStructName).activeGroup.groupFiles)
            FV_img.(currentStructName).activeGroup.groupFiles = currentGroupFile;
        else
            groupFileNames = {FV_img.(currentStructName).activeGroup.groupFiles.fname};
            if ~ismember(lower(currentGroupFile.fname), lower(groupFileNames))
                FV_img.(currentStructName).activeGroup.groupFiles(end+1) = currentGroupFile;
            end
        end
    end
    time = datenum({FV_img.(currentStructName).activeGroup.groupFiles.date}');
    [sortedTime, index] = sort(time);
    FV_img.(currentStructName).activeGroup.groupFiles =  FV_img.(currentStructName).activeGroup.groupFiles(index);
    groupFiles =  FV_img.(currentStructName).activeGroup.groupFiles;
    save(fullfile(FV_img.(currentStructName).activeGroup.groupPath, FV_img.(currentStructName).activeGroup.groupName),'groupFiles');
end
FV_updateInfo(handles);


function FV_newGroup(handles)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

[fname,fpath] = uiputfile('*.grp','Please specify a group name.');
if fname == 0
    return;
else
    [pname, fname2, fExt] = fileparts(fname);
    if isempty(fExt)||strcmp(fExt, '.')
        fname = [fname2,'.grp'];
    end        
end

groupFiles = [];
save([fpath,fname],'groupFiles');
% set(handles.currentGroupInfo,'String',['Active Group: ',fname],'FontSize',9);
FV_img.(currentStructName).activeGroup.groupName = fname;
FV_img.(currentStructName).activeGroup.groupPath = fpath;
FV_img.(currentStructName).activeGroup.groupFiles = groupFiles;
FV_updateInfo(handles);


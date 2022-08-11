function FV_searchAndAddToGroup(handles)

global FV_img;

UData = get(handles.FV_searchForGroupGUI, 'UserData');
FVStructName = ['Inst', num2str(UData.instanceInd)];

pathname = get(handles.pathName,'String');
basename = get(handles.fileBasename,'String');
fileExtension = get(handles.fileExtensionOpt,'String');
if get(handles.searchSubdirOpt,'Value')
    searchOpt = '/s';
else
    searchOpt = '';
end
fileNumbers = get(handles.fileNumbers,'String');
if strcmpi(fileNumbers,'all')
%     str = {'*'};
    str = {''};
else
    numbers = eval(['[',fileNumbers,']']);
    str = {};
    for i = 1:length(numbers)
        str1 = '000';
        str2 = num2str(numbers(i));
        str1(end-length(str2)+1:end) = str2;
        str(i,1) = {str1};
    end
end

files = [];
% tic
for i = 1:length(str)
    filename = [basename,str{i},'*',fileExtension];
    files = [files;h_dir(fullfile(pathname,filename),searchOpt)]; 
    % the above gets very slow for larger file numbers. So try to fix it.
    % Note fix below not working. Also, this is not the limiting step. The
    % limiting step is in saving.
    
%     if i == 1 % this does not work as each search may result in many files.
%         files = h_dir(fullfile(pathname,filename),searchOpt);
%         files = repmat(files(1), [length(str), 1]);
%     else
%         files(i) = h_dir(fullfile(pathname,filename),searchOpt);
%     end
%     toc    
end
% toc

I = [];
for i = 1:length(files)
    if strfind(files(i).name,'max.')
        I = [I,i];
    end
end
% toc

maxOpt = get(handles.maxOpt,'Value');    
if maxOpt
    files = files(I);
else
    files(I) = [];
end

% include files ONLY immediately under 'spc' folder.
I2 = [];
for i = 1:length(files)
    pname1 = fileparts(files(i).name);
    [pname2, fname2, fExt2] = fileparts(pname1);
    %     if strfind(files(i).name,'\spc\')% this is probably not compatible across platforms.
    if strcmpi(fname2, 'spc')
        I2 = [I2,i];
    end
end
files = files(I2);

% for i = 1:length(files)
%     FV_addToCurrentGroup(FV_img.(FVStructName).gh.currentHandles, files(i).name);
% end
FV_addToCurrentGroup(FV_img.(FVStructName).gh.currentHandles, {files.name});%it can now handle many files in a string cell.

close(handles.FV_searchForGroupGUI);
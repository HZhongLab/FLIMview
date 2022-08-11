function [D,num] = h_dir(directory_name,opt)

if ~exist('directory_name')|isempty(directory_name)
    directory_name = pwd;
end

currentpath = pwd;
if ~isdir(directory_name)
    [pname, fname] = h_analyzeFilename(directory_name);
else
    pname = directory_name;
    fname = '';
end
if ~isempty(pname)
    if exist(pname) == 7
        cd(pname);
    else
        D = [];
        num = 0;
    end
else
    pname = pwd;
end
if isempty(fname)
    fname = '*.*';
end
D = dir(fname);
for i = 1:length(D)
    D(i).name = fullfile(pwd,D(i).name);
end
num = 1;
cd(currentpath);

if exist('opt') & strcmp(opt,'/s')
    all = dir(pname);
    subdir = all(cell2mat({all.isdir})==1);
    I = strmatch('.',{subdir.name}','exact');
    subdir(I) = [];
    I = strmatch('..',{subdir.name}','exact');
    subdir(I) = [];
    for i = 1:length(subdir)
        [D_sub,num_sub] = h_dir(fullfile(pname,subdir(i).name,fname),'/s');
        D = [D;D_sub];
        num = num + num_sub;
    end
end

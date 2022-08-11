function relativePath = h_getRelativePath(path1, path2)

% this function try to get the relative path from path1 to path2.

length1 = length(path1);
length2 = length(path2);

minLength = min([length1, length2]);

ind = find(~(lower(path1(1:minLength))==lower(path2(1:minLength))),1);%1:ind-1 are the same for both paths.
if isempty(ind)
    ind = minLength+1;
else
    if ~strcmpi(path1(ind-1),filesep)%note filesep is a function = file separator.
        [pname, fname] = fileparts(path1(1:ind-1));%in this case, the last bit is part of directory name that is different between paths.
        ind = ind-length(fname);
    end
end

path1a = path1(ind:end);
path2a = path2(ind:end);

if ~isempty(path1a) && strcmpi(path1a(1), filesep)% without this, fileparts('\') = '\'; loop will never end.
    path1a(1) = [];
end

if ~isempty(path2a) && strcmpi(path2a(1), filesep)% without this, fullfile('', '\aa') = '\aa';
    path2a(1) = [];
end

pname = path1a;
% i = 0;
relativePath = '';
while ~isempty(pname)
    pname = fileparts(pname);
%     i = i + 1;
    relativePath = fullfile(relativePath, '..');
end



relativePath = fullfile(relativePath, path2a);





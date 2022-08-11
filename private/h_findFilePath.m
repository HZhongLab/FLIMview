function pname = h_findFilePath(fname)

% This is to find the path to a file, e.g. a function, that is in Matlab
% path.

if exist(fname, 'file')
    FID = fopen(fname);
    filename = fopen(FID);
    fclose(FID);
    pname = fileparts(filename);
else
    error(['no such file:    ', fname]);
end
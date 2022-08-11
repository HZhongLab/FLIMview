function data = h_AST_readData(filename)

fid = fopen(filename);
data = fread(fid, inf, 'double');
fclose(fid);

[pname, fname, fExt] = fileparts(filename);
if strcmpi(fExt, '.dat2')
    data = reshape(data, [5, numel(data)/5]);
else
    data = reshape(data, [2, numel(data)/2]);
end
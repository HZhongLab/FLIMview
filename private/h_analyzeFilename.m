function [pname, fname] = h_analyzeFilename(filename)


[pname, name, ext] = fileparts(filename);

fname = [name, ext];

%pos = strfind(filename,'\');
%if ~isempty(pos)
%    pname = filename(1:pos(end));
%    fname = filename(pos(end)+1:end);
%else
%    pname = '';
%    fname = filename;
%end



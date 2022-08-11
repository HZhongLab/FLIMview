function str = h_showunderscore(str)

if iscell(str)
    for i = 1:length(str)
        str{i} = showunderscore(str{i});
    end
else
    str = showunderscore(str);
end

        
function str = showunderscore(str)
pos = strfind(str,'_');

if ~isempty(pos)
    for i = pos(end:-1:1)
        str = [str(1:i-1),'\',str(i:end)];
    end
end

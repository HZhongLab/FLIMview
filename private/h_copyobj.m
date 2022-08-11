function C = h_copyobj(varargin)

% this is to detect the Mablab version and for 2014b and later, use
% copyobj(..., 'legacy'). This way, callback properties are also copied in
% the newer versions.

ver = version;
I = strfind(ver, '.');
verNum = eval(ver(1:I(2)-1)); % handle this way because Matlab will soon become verions 10 and the digit increase

if verNum<=8.3 %2014a is version 8.3
    C = copyobj(varargin{:});
else
    C = copyobj(varargin{:}, 'legacy');
end
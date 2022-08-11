function h = h_findobj(varargin)

currentValue = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles', 'on');
h = findobj(varargin{:});
set(0,'ShowHiddenHandles', currentValue);
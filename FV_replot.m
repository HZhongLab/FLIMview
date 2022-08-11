function FV_replot(handles, mode)

global FV_img

if ~exist('mode', 'var') || isempty(mode)
    mode = 'slow';
end

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

if ~strcmpi(mode,'fast')
    FV_getCurrentImg(handles); % this generates display.intensityImg and display.lifetimeImg
    currentStruct = FV_img.(currentStructName);
end

display = currentStruct.display;

%%%% first handling intensity image.
axes(handles.intensityImgAxes);
switch currentStruct.state.intensityCMapOpt.value
    case 1
        cmap = gray;
    case 2
        cmap = jet(64);
end

colormap(cmap);

c = findobj(handles.intensityImgAxes,'Type','image');
cLimit = display.settings.intensityLimit;
if isempty(c)
    c = imagesc(display.intensityImg,cLimit);
else
    set(c,'CData',display.intensityImg,'CDataMapping','scaled');
end          
set(c,'ButtonDownFcn','FV_doubleClickMakeROI');
set(handles.intensityImgAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'intensityImgAxes',...
    'CLim',cLimit,'ButtonDownFcn','FV_doubleClickMakeROI' );
% colorbar('peer',handles.spc_intensityColorbarAxes); %HN 2016-01-20
FV_colorbar(handles.intensityColorbarAxes, cmap, cLimit, 'left', 'intensityColorbarAxes')
% set(handles.intensityColorbarAxes,'YAxisLocation','left','Tag','intensityColorbarAxes');
% axis square

%%%%%%%%%%% Handling Lifetime %%%%%%%%%%%%%%%%%%
axes(handles.lifetimeImgAxes);
c = findobj(handles.lifetimeImgAxes,'Type','image');

rgbimage = ss_makeRGBLifetimeMap(display.activityImg, display.settings.lifetimeLimit, ...
    display.intensityImg, display.settings.lifetimeLumLimit);
if isempty(c)
    c = image(rgbimage);
else
    set(c,'CData',rgbimage,'CDataMapping','scaled');
end
set(c,'ButtonDownFcn','FV_doubleClickMakeROI');
set(handles.lifetimeImgAxes, 'XTickLabel', '', 'XTick',[],'YTickLabel', '', 'YTick',[],'Tag', 'lifetimeImgAxes',...
    'ButtonDownFcn','FV_doubleClickMakeROI' );
cmap = jet(64);
cmap2 = cmap(9:56,:);
FV_colorbar(handles.lifetimeColorbarAxes, cmap2, display.settings.lifetimeLimit(end:-1:1), 'right', 'lifetimeColorbarAxes')

% ss_lifetimeColorbar(handles.spc_lifetimeColorbarAxes,currentStruct.spc.switches.lifetime_limit);
% set(handles.spc_lifetimeColorbarAxes,'Tag','spc_lifetimeColorbarAxes');
% axis square



function FV_colorbar(h, cmap, label, YAxisLocation, tagName)

if ~exist('YAxisLocation', 'var') || ~ischar(YAxisLocation)
    YAxisLocation = 'left';
end

siz = size(cmap); % siz(2) has to be 3.
cmapImg = reshape(cmap,[siz(1),1,siz(2)]);

o = findobj(h,'Type','image');
if isempty(o)
    axes(h);
    image(cmapImg);
else
    set(o,'CData',cmapImg);
end
set(h,'XTickLabel', [], 'YLim', [0.5, siz(1)+0.5], 'YDir', 'normal', 'YTick', [1,siz(1)], 'YTickLabel', label,...
    'YAxisLocation',YAxisLocation, 'Tag', tagName); % resetting the tag seems to be necessary. Otherwise it get lost somehow...
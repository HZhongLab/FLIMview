function data = FV_frameAnalysisPlot(handles)

% global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

fig = findobj('Tag','FVPlot','Selected','on');
if isempty(fig)
    fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot','Selected','on');
end
fig = fig(1);% just in case there are more than one.
figure(fig);
plotParameters = FV_getFrameAnalysisPlotParameters(handles);
if plotParameters.holdPlot
    hold on;
else
    hold off;
end

currentFileName = currentStruct.info.filename;
[pname, fname, fExt] = fileparts(currentFileName);% fname -s filename without extention.
analysisNumber = currentStruct.state.analysisNum.value;
dataFilename = fullfile(pname,'Analysis',[fname,'_FVframeAnalysis_A',num2str(analysisNumber),'.mat']);

% load data
if exist(dataFilename, 'file')
    data = load(dataFilename);
    data = data.Aout; % note: using cell is not good. cause error for calculating time.
else
    error(['File not found: ', dataFilename]);
end

frameNum = data.includedZ;
frameNum = frameNum - frameNum(plotParameters.baselinePos(end)); % note this is position in the groupfile, not the file number.

plotDataOpt = get(handles.frameAnalysisPlotDataOpt,'Value');

roiGrp = [];
for i = 1:length(plotParameters.roiGrp)% since the plot do not average, combine all groups.
    if ~ischar(plotParameters.roiGrp{i})
        roiGrp = unique(horzcat(roiGrp, plotParameters.roiGrp{i})); 
    else
        roiGrp = data.ROINumber; % if there is any "all", just include everything.
        break
    end
end
currentROIInd = find(ismember(data.ROINumber, roiGrp));

switch plotDataOpt
    case {1} % mean intensity
        ydata = data.avgIntensity(:,currentROIInd);%first dimension are frames, second is ROIs
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Frame number');
        ylabel('Averaged intensity');
        title(h_showunderscore(['Averaged intensity for ',fname]));
        set(fig,'Name',['Averaged intensity for ',fname]);
    case {2} % total intensity
        ydata = data.integratedIntensity(:,currentROIInd);%first dimension are frames, second is ROIs
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Frame number');
        ylabel('Integrated intensity');
        title(h_showunderscore(['Integrated intensity for ',fname]));
        set(fig,'Name',['integrated intensity for ',fname]);
    case {3} % norm. intensity
        ydata = data.avgIntensity(:,currentROIInd);%first dimension are frames, second is ROIs
        ref = mean(ydata(plotParameters.baselinePos,:), 1);
        ydata = ydata./repmat(ref, size(ydata, 1), 1);
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Frame number');
        ylabel('Normalized intensity');
        title(h_showunderscore(['Normalized intensity for ',fname]));
        set(fig,'Name',['Normalized intensity for ',fname]);
    case 4 % MPET
        ydata = data.MPET(:,currentROIInd);%first dimension are frames, second is ROIs
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Frame number');
        ylabel('MPET (ns)');
        title(h_showunderscore(['MPET for ',fname]));
        set(fig,'Name',['MPET for ',fname]);
    case 5 % baseline subtracted MPET
        ydata = data.MPET(:,currentROIInd);%first dimension are frames, second is ROIs
        ref = mean(ydata(plotParameters.baselinePos,:), 1);
        ydata = ydata - repmat(ref, size(ydata, 1), 1);
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Time (min)');
        ylabel('deltaMPET (ns)');
        title(h_showunderscore(['deltaMPET for ',fname]));
        set(fig,'Name',['deltaMPET for ',fname]);
    case 6 % deltaMPET/MPET0
        ydata = data.MPET(:,currentROIInd);%first dimension are frames, second is ROIs
        ref = mean(ydata(plotParameters.baselinePos,:));
        ydata = ydata - repmat(ref, size(ydata, 1), 1);
        ydata = ydata ./ repmat(ref, size(ydata, 1), 1);
        h = FV_frameAnalysisPlot_plot(frameNum,ydata, plotParameters);
        xlabel('Frame number');
        ylabel('deltaMPET/MPET0');
        title(h_showunderscore(['deltaMPET/MPET0 for ',fname]));
        set(fig,'Name',['deltaMPET/MPET0 for ',fname]);
    otherwise
        
end

if length(frameNum)>1 % for adding a label for each trace
    x = frameNum(1) + (frameNum(end) - frameNum(1))*1.02;
else
    x = frameNum(1) * 1.02;
end

for i = 1:length(currentROIInd)
    y = ydata(end,i);
    text(x,y,num2str(data(1).ROINumber(currentROIInd(i))));
end

hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = FV_frameAnalysisPlot_plot(time,ydata, plotParameters)

if strcmpi(plotParameters.colorStr, 'auto')
    h = plot(time, ydata, plotParameters.styleStr);
else
    h = plot(time, ydata, plotParameters.styleStr, 'color', plotParameters.colorStr);
end
h_copy(ydata, 'horizontal');

set(h,'ButtonDownFcn','FV_selectFrameAnalysisPlotLine');
xlim(plotParameters.xlim);
ylim(plotParameters.ylim);

axesobj = get(h(1),'Parent');
set(axesobj,'ButtonDownFcn','FV_unSelectLine');


function Aout = FV_getFrameAnalysisPlotParameters(handles)

Aout.holdPlot = get(handles.frameAnalysisHoldPlotOpt, 'value');

Aout.grpPlotAvgOpt = get(handles.frameAnalysisGrpPlotAvgOpt, 'value'); % this is not need here but keep for frameAnalysisGrpPlot

baselineStr = get(handles.frameAnalysisBaselineNum, 'string');
try
    Aout.baselinePos = eval(['[',baselineStr,']']); % note this is position in the groupfile, not the file number.
catch
    Aout.baselinePos = 1; % if not real number, use the first one as baseline.
end

ROIStr = get(handles.frameAnalysisPlotROINum, 'string');

try %plot has no avg. any avg should go through mergeROI. but still keep for frameAnalysisGrpPlot.
    I = strfind(ROIStr,'/');
    I = horzcat(0,I, length(ROIStr)+1);
    for i = 1:length(I)-1
        if ~isempty(strfind(lower(ROIStr(I(i)+1:I(i+1)-1)),'all'))
            Aout.roiGrp{i} = 'all';
        else
            Aout.roiGrp{i} = eval(['[',ROIStr(I(i)+1:I(i+1)-1),']']);
        end
    end
catch
    error(['error in evaluating ROI group str: [',ROIStr(I(i)+1:I(i+1)-1),']'])
end


try
    Aout.xlim = eval(['[', get(handles.frameAnalysisXLimSetting, 'string'), ']']);
catch
    Aout.xlim = 'auto';
end

try
    Aout.ylim = eval(['[', get(handles.frameAnalysisYLimSetting, 'string'), ']']);
catch
    Aout.ylim = 'auto';
end

plotColorOpt = get(handles.frameAnalysisLineColorOpt, 'value'); % this is simpler coding than below.
plotColorStr = get(handles.frameAnalysisLineColorOpt, 'String'); % this should be a cell.
if plotColorOpt == 1; % 1 is default, same as 2.
    plotColorOpt = 2;
end
Aout.colorStr = plotColorStr{plotColorOpt};


plotStyleOpt = get(handles.frameAnalysisLineStyleOpt, 'value');
plotStyleStr = get(handles.frameAnalysisLineStyleOpt, 'String'); % this should be a cell.
if plotStyleOpt == 1; % 1 is default, same as 2.
    plotStyleOpt = 2;
end
Aout.styleStr = plotStyleStr{plotStyleOpt};
        
    



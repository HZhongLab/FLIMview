function grpData = FV_plotGroupFcn(handles)

% global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

fig = findobj('Tag','FVPlot','Selected','on');
if isempty(fig)
    fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot','Selected','on');
end
fig = fig(1);% just in case there are more than one.
figure(fig);

plotAxes = findobj(fig, 'Type', 'Axes'); 
activityAxes = findobj(fig, 'Type', 'Axes', 'Tag', 'activityAxes');
if ~isempty(plotAxes)
    if ~isempty(activityAxes)
        plotAxes(plotAxes==activityAxes) = [];
    end
    axes(plotAxes);
end
        
grpPlotParameters = FV_getGrpPlotParameters(handles);
if grpPlotParameters.holdGrpPlot
    hold on;
else
    hold off;
end


for i = 1:length(currentStruct.activeGroup.groupFiles)
    filename = currentStruct.activeGroup.groupFiles(i).fname;
    [pname, fname, fExt] = fileparts(filename);% fname -s filename without extention.
    
    pathname = fullfile(currentStruct.activeGroup.groupPath, currentStruct.activeGroup.groupFiles(i).relativePath);
    if ~exist(pathname, 'dir') % if relative path does not work, try absolute path
        pathname = currentStruct.activeGroup.groupFiles(i).path;
    end
    
    analysisNumber = currentStruct.state.analysisNum.value;

    dataFilename = fullfile(pathname,'Analysis',[fname,'_FVROI_A',num2str(analysisNumber),'.mat']);
    if exist(dataFilename, 'file')
        try
            data = load(dataFilename);
            grpData(i) = data.Aout; % note: using cell is not good. cause error for calculating time.
        catch
            error(['Error in loading file: ', dataFilename]); % add this to help identifying problems if happening.
        end
    else
        error(['File not found: ', dataFilename]);
    end
end

try % in the past, often error here. 
    time = datenum({grpData.timestr})*24*60; % need to check whether this is possible.
catch
	error(['Timestr error: ', dataFilename]);
end

time = time - min(time);
time = time - time(grpPlotParameters.baselinePos(end)); % note this is position in the groupfile, not the file number.

grpPlotDataOpt = get(handles.grpPlotDataOpt,'Value');

roiGrp = grpPlotParameters.roiGrp;
% roiVol = [grpData.roiVol];
% roiVolTotal = vertcat(roiVol.total); % currently dimension 1 is diff files, dimension 2 is diff ROIs.

for ii = 1:length(roiGrp)
    if ischar(roiGrp{ii}) && strcmpi(roiGrp{ii}, 'all')
        currentROIInd = 1:length(grpData(1).ROINumber);
    else
        currentROIInd = find(ismember(grpData(1).ROINumber, roiGrp{ii}));
    end
    if ii>1
        hold on
    end

    switch grpPlotDataOpt
        case {1} % mean intensity
            ydata = vertcat(grpData.avgIntensity);
            ydata = ydata(:,currentROIInd);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('averaged intensity');
            title(h_showunderscore(['averaged intensity for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['averaged intensity for ',currentStruct.activeGroup.groupName]);
        case {2} % total intensity
            ydata = vertcat(grpData.integratedIntensity);
            ydata = ydata(:,currentROIInd);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('integrated intensity');
            title(h_showunderscore(['integrated intensity for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['integrated intensity for ',currentStruct.activeGroup.groupName]);
        case {3} % norm. intensity
            ydata = vertcat(grpData.avgIntensity);
            ref = mean(ydata(grpPlotParameters.baselinePos,:), 1);
            ydata = ydata(:,currentROIInd)./repmat(ref(1, currentROIInd), size(ydata, 1), 1);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('Normalized intensity');
            title(h_showunderscore(['Normalized intensity for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['Normalized intensity for ',currentStruct.activeGroup.groupName]);
        case 4 % MPET
            ydata = vertcat(grpData.MPET);
            ydata = ydata(:,currentROIInd);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('MPET (ns)');
            title(h_showunderscore(['MPET for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['MPET for ',currentStruct.activeGroup.groupName]);
        case 5 % baseline subtracted MPET
            ydata = vertcat(grpData.MPET);
            ref = mean(ydata(grpPlotParameters.baselinePos,:), 1);
            ydata = ydata(:,currentROIInd) - repmat(ref(1, currentROIInd), size(ydata, 1), 1);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('deltaMPET (ns)');
            title(h_showunderscore(['deltaMPET for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['deltaMPET for ',currentStruct.activeGroup.groupName]);
        case 6 % deltaMPET/MPET0
            ydata = vertcat(grpData.MPET);
            ref = mean(ydata(grpPlotParameters.baselinePos,:), 1);
            ydata = ydata(:,currentROIInd) - repmat(ref(1, currentROIInd), size(ydata, 1), 1);
            ydata = ydata ./ repmat(ref(1, currentROIInd), size(ydata, 1), 1);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('deltaMPET/MPET0');
            title(h_showunderscore(['deltaMPET/MPET0 for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['deltaMPET/MPET0 for ',currentStruct.activeGroup.groupName]);  
        case 7 % binding ratio (calculated)
            bindingPct = vertcat(grpData.bindingPct);
            ydata = vertcat(bindingPct.calc);
            ydata = ydata(:,currentROIInd)*100;
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('Binding Pct (%)');
            title(h_showunderscore(['Binding Pct for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['Binding Pct for ',currentStruct.activeGroup.groupName]);
        case 8
        case 9 % z
            ydata = zeros(length(grpData), length(grpData(1).ROINumber));%ROI #0 is not in allROIInfo.ROI.
            for i = 1:length(grpData)
                ydata(i, 1) = mean(grpData(i).currentSettings.display.zLimit);%this is ROI 0. zlimit may be different across cells.
                for j = 1:length(grpData(i).ROINumber)-1
                    ydata(i, j+1) = mean(grpData(i).allROIInfo.ROI(j).includedZ);
                end
            end
            ydata = ydata(:,currentROIInd);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('depth (secton #)');
            title(h_showunderscore(['depth (secton #) for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['depth (secton #) for ',currentStruct.activeGroup.groupName]); 
        case 10 % est. error
            ydata = vertcat(grpData.estMPETError);
            ydata = ydata(:,currentROIInd);
            h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters);
            xlabel('Time (min)');
            ylabel('Est. MPET error (ns)');
            title(h_showunderscore(['Est. MPET error for ',currentStruct.activeGroup.groupName]));
            set(fig,'Name',['Est. MPET error for ',currentStruct.activeGroup.groupName]);

        otherwise

    end

%     h_copy(horzcat(time, ydata)');%copy is now done in FV_plotGroupFcn_plot.

    LineData.activeGroup = currentStruct.activeGroup;
    LineData.timeLastClick = clock;
    LineData.parentGUIFigureHandle = handles.FLIMview;
    set(h,'UserData',LineData);

    if length(time)>1 % for adding a label for each trace
        x = time(1) + (time(end) - time(1))*1.02;
    else
        x = time(1) * 1.02;
    end
    if grpPlotParameters.grpPlotAvgOpt>1
        y = mean(ydata(end,:));
        text(x,y,['avg#',num2str(grpData(1).ROINumber(currentROIInd))]);
    else
        for i = 1:length(currentROIInd)
            y = ydata(end,i);
            text(x,y,num2str(grpData(1).ROINumber(currentROIInd(i))));
        end
    end
end

hold off;

% to add activity plot
if isfield(currentStruct,'associatedData') && ismember(currentStruct.state.AST_plotOpt.value, [4 7 10 13 16]) 
    % first set the plot axes smaller.
    plotAxes = findobj(fig, 'Type', 'Axes'); %These also need to be set earlier otherwise not knowing which axes to plot.
    % find plotAxes again as for a new figure, there was not plotAxes.
    %     activityAxes = findobj(fig, 'Type', 'Axes', 'Tag', 'activityAxes');
    if ~isempty(activityAxes)
        plotAxes(plotAxes==activityAxes) = [];
    else
        pos = get(plotAxes, 'Position');
        newPos = pos;
        newPos(4) = pos(4)*0.55;
        newPos(2) = pos(2)+pos(4)-newPos(4);
        set(plotAxes, 'position', newPos);
        
        newPos2 = pos;
        newPos2(4) = pos(4)*0.25;
        activityAxes = axes('Position', newPos2, 'Tag', 'activityAxes');
    end
        
    activityData = currentStruct.associatedData.animalState;
        
    filename = currentStruct.activeGroup.groupFiles(grpPlotParameters.baselinePos(end)).fname;
    [pname, fname, fExt] = fileparts(filename);% fname is filename without extention.
    pathname = fullfile(currentStruct.activeGroup.groupPath, currentStruct.activeGroup.groupFiles(grpPlotParameters.baselinePos(end)).relativePath);
    if ~exist(pathname, 'dir') % if relative path does not work, try absolute path
        pathname = currentStruct.activeGroup.groupFiles(1).path;
    end
    imgFileName = fullfile(pathname,[fname,fExt]);

    % need to offset the time zero by half of image duration and by the time zero position
%         t0 = datenum(grpData(1).timestr);
    fileInfo = h_dir(imgFileName);
    imgDurationEst = datenum(fileInfo.date) - datenum(grpData(grpPlotParameters.baselinePos(end)).timestr); % fileInfo.date should be close to end of image acq.
    if imgDurationEst*24*60 > time(grpPlotParameters.baselinePos(end)+1) - time(grpPlotParameters.baselinePos(end))
        imgDurationEst = 0;
    end
    
    t0 = datenum(grpData(grpPlotParameters.baselinePos(end)).timestr) + imgDurationEst/2; 
    
    time = (activityData.absDateNum - t0)*24*60;
    
    if ~ismember(currentStruct.state.AST_plotOpt.value, [10, 13, 16])
        if currentStruct.state.AST_plotOpt.value==4
            toBePlot = 'activity';
        else
            toBePlot = 'rawData';
        end
        
        plot(activityAxes, time, activityData.(toBePlot));
    else% integrated activity
        if currentStruct.state.AST_plotOpt.value==10 % 1 pont per minute
            ptsPerMin = 1;
        elseif currentStruct.state.AST_plotOpt.value==13 % 6 point per min
            ptsPerMin = 6;
        else
            ptsPerMin = 60;
        end
        
        % Below is slow. Try to make it faster. Problem is that data is not
        % always continuous. There can be breaks. But it is really taking
        % too long. So using smooth function as a proxy.
        deltaT = mean(diff(activityData.relativeTimeInMin(10:100))); % assuming no interruption in the first 100 pts but first a few are usually off.
        NumPtToSmooth = round(1/deltaT/ptsPerMin);
        avgData = smooth(activityData.activity, NumPtToSmooth);
        time1 = smooth(time, NumPtToSmooth);
        % downsample:
        time1 = time1(round(NumPtToSmooth/2):NumPtToSmooth:end);
        avgData = avgData(round(NumPtToSmooth/2):NumPtToSmooth:end);
        
%         avgData = zeros(1,ceil((max(time)-min(time))*ptsPerMin));
%         time1 = zeros(1,ceil((max(time)-min(time))*ptsPerMin));
%         i = 1;
%         for t = ceil(min(time)*ptsPerMin)/ptsPerMin:1/ptsPerMin:ceil(max(time)*ptsPerMin)/ptsPerMin
%             I = time<t & time>=t-1/ptsPerMin;
%             avgData(i) = mean(activityData.activity(I));
%             time1(i) = mean(time(I));
%             i = i + 1;
%         end
        plot(activityAxes, time1, avgData);
    end
    
    title(['t0 = ', datestr(activityData.absDateNum(1))]);
    xLim = get(plotAxes, 'XLim');
    set(activityAxes, 'XLim', xLim);
    xlabel(activityAxes, 'Time (min)');
    set(activityAxes, 'Tag', 'activityAxes');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = FV_plotGroupFcn_plot(time,ydata, grpPlotParameters)


switch grpPlotParameters.grpPlotAvgOpt
    case 1
        if strcmpi(grpPlotParameters.colorStr, 'auto')
            h = plot(time, ydata, grpPlotParameters.styleStr);
        else
            h = plot(time, ydata, grpPlotParameters.styleStr, 'color', grpPlotParameters.colorStr);
        end
        h_copy(ydata, 'vertical');
    case 2
        if strcmpi(grpPlotParameters.colorStr, 'auto')
             h = plot(time, mean(ydata,2), grpPlotParameters.styleStr);
        else
            h = plot(time, mean(ydata,2), grpPlotParameters.styleStr, 'color', grpPlotParameters.colorStr);
        end
        h_copy(mean(ydata,2), 'vertical');
    case 3
        if strcmpi(grpPlotParameters.colorStr, 'auto')
            h = errorbar(time, mean(ydata,2),std(ydata,0,2), grpPlotParameters.styleStr);
        else
            h = errorbar(time, mean(ydata,2),std(ydata,0,2), grpPlotParameters.styleStr, 'color', grpPlotParameters.colorStr);
        end
        h_copy(horzcat(mean(ydata,2),std(ydata,0,2)), 'vertical');
    case 4
        if strcmpi(grpPlotParameters.colorStr, 'auto')
            h = errorbar(time, mean(ydata,2),std(ydata,0,2)/sqrt(size(ydata,2)), grpPlotParameters.styleStr);
        else
            h = errorbar(time, mean(ydata,2),std(ydata,0,2)/sqrt(size(ydata,2)), grpPlotParameters.styleStr,...
                'color', grpPlotParameters.colorStr);
        end
        h_copy(horzcat(mean(ydata,2),std(ydata,0,2)/sqrt(size(ydata,2))), 'vertical');
end
set(h,'ButtonDownFcn','FV_selectLine');
xlim(grpPlotParameters.xlim);
ylim(grpPlotParameters.ylim);

axesobj = get(h(1),'Parent');
set(axesobj,'ButtonDownFcn','FV_unSelectLine');


function Aout = FV_getGrpPlotParameters(handles)

Aout.holdGrpPlot = get(handles.holdGrpPlot, 'value');

Aout.grpPlotAvgOpt = get(handles.grpPlotAvgOpt, 'value');

baselineStr = get(handles.baselinePos, 'string');
try
    Aout.baselinePos = eval(['[',baselineStr,']']); % note this is position in the groupfile, not the file number.
catch
    Aout.baselinePos = 1; % if not real number, use the first one as baseline.
end

ROIStr = get(handles.grpPlotROIOpt, 'string');

try
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
    Aout.xlim = eval(['[', get(handles.xLimSetting, 'string'), ']']);
catch
    Aout.xlim = 'auto';
end

try
    Aout.ylim = eval(['[', get(handles.yLimSetting, 'string'), ']']);
catch
    Aout.ylim = 'auto';
end

grpPlotColorOpt = get(handles.grpPlotColorOpt, 'value'); % this is simpler coding than below.
grpPlotColorStr = get(handles.grpPlotColorOpt, 'String'); % this should be a cell.
if grpPlotColorOpt == 1; % 1 is default, same as 2.
    grpPlotColorOpt = 2;
end
Aout.colorStr = grpPlotColorStr{grpPlotColorOpt};
        
% switch get(handles.grpPlotColorOpt, 'value')
%     case {1, 2}
%         Aout.colorStr = 'auto';
%     case 3
%         Aout.colorStr = 'red';
%     case 4
%         Aout.colorStr = 'blue';
%     case 5
%         Aout.colorStr = 'magenta';
%     case 6
%         Aout.colorStr = 'cyan';
%     case 7
%         Aout.colorStr = 'green';
%     case 8
%         Aout.colorStr = 'yellow';
%     case 9
%         Aout.colorStr = 'black';
%     otherwise
%         Aout.colorStr = 'auto';
% end

grpPlotStyleOpt = get(handles.grpPlotStyleOpt, 'value');
grpPlotStyleStr = get(handles.grpPlotStyleOpt, 'String'); % this should be a cell.
if grpPlotStyleOpt == 1; % 1 is default, same as 2.
    grpPlotStyleOpt = 2;
end
Aout.styleStr = grpPlotStyleStr{grpPlotStyleOpt};
        
    



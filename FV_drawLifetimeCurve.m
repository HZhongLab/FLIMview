function FV_drawLifetimeCurve(handles)

% global h_spc

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

currentFilename = currentStruct.info.filename;
[pname, fname, fExt] = fileparts(currentFilename);
fnameWExt = [fname, fExt];

if ~isfield(currentStruct.lastAnalysis,'calcFVROI') ||...
        ~strcmpi(fnameWExt,currentStruct.lastAnalysis.calcFVROI.filename(end-length(fnameWExt)+1:end))
    analysisNumber = currentStruct.state.analysisNum.value;
    roiFilename = fullfile(pname,'Analysis',[fname,'_FVROI_A',num2str(analysisNumber),'.mat']);
    if exist(roiFilename, 'file')
        FV_loadAnalyzedROI(handles);
    else
        FV_img.(currentStructName).lastAnalysis.calcFVROI = FV_executeCalcROI(handles);
    end
end

FV_drawLifetimeCurve_plot(handles);


function FV_drawLifetimeCurve_plot(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

calcFVROI = currentStruct.lastAnalysis.calcFVROI;

plotROInum = currentStruct.state.drawLifetimeROINum.string;
if ~isempty(strfind(lower(plotROInum),'all'))
    ROIInd = 1:length(calcFVROI.ROINumber); 
else
    ROIInd = unique(eval(['[',plotROInum,']']));
    ROIInd = find(ismember(calcFVROI.ROINumber, ROIInd));
end

spcRange = [str2double(currentStruct.state.lifetimeSPCRangeStrLow.string),...
    str2double(currentStruct.state.lifetimeSPCRangeStrHigh.string)];
spcRangeInd = round(spcRange*1000/currentStruct.info.datainfo.psPerUnit);

t = [spcRangeInd(1):spcRangeInd(2)]*currentStruct.info.datainfo.psPerUnit/1000;

fig = findobj('Tag','FVPlot', 'Type', 'figure', 'Selected', 'on');
if isempty(fig)
    fig = figure('Tag','FVPlot','ButtonDownFcn','FV_selectCurrentPlot', 'Name', 'Lifetime Curve');
    FV_selectCurrentPlot;
end
fig = fig(1);
figure(fig);
if currentStruct.state.holdLifetimePlot.value
    hold on;
end

for i = 1:length(ROIInd)
    ydata = calcFVROI.lifetimeCurve{ROIInd(i)}(spcRangeInd(1):spcRangeInd(2));
    h = semilogy(t,ydata,'b-');
    hold on;
    x = t(end)*1.02;
    y = ydata(end);
    text(x,y,num2str(calcFVROI.ROINumber(ROIInd(i))));
    UserData.filename = calcFVROI.filename;
    UserData.ROINumber = calcFVROI.ROINumber(ROIInd(i));
    UserData.lifetimeCurveHandle = h;
    UserData.fitCurveHandle = [];
    set(h,'UserData',UserData,'Tag','FV_lifetimeCurve','ButtonDownFcn','FV_selectFrameAnalysisPlotLine');
    % note: FV_selectFrameAnalysisPlotLine only select the line, while
    % FV_selectLine also try to open files in group so it is more for group
    % plots.
    axesobj = get(h,'Parent');
    set(axesobj,'ButtonDownFcn','FV_unSelectLine');
end
hold off;
xlabel('Time (ns)');
ylabel('Intensity');
[pname, fname, fExt] = fileparts(calcFVROI.filename);
set(fig,'Name',['Lifetime Curve for ',fname, fExt]);


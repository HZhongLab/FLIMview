function Aout = FV_executeFrameAnalysisCalc(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

t0 = currentStruct.display.settings.t0;
zLim = currentStruct.display.settings.zLimit;

fname = get(handles.currentFileName,'String');
[filepath,filename,fExt] = fileparts(fname);

siz = size(currentStruct.image.intensity);

% initialized Aout so that the structure is consistent across files.
Aout = struct('currentSettings', struct('display', struct, 'state', struct), 'allROIInfo', [], 'bgIntensity', [], 'ROINumber',[],...
    'includedZ', [], 'avgIntensity', [], 'integratedIntensity', [], 'maxIntensity', [], 'MPET', [], 'threshForMPET', [], 'includedPhotonNum', [],...
    'estMPETError', [], 'roiVol', struct('total', [], 'aboveThresh', [], 'pctIncluded', []), 'lifetimeCurve', {},...
    'lifetimeCurveFit', struct, 'timestr', '', 'filename', '');
% note: roiVol is a structure of three fields: total, aboveThresh and pctIncluded

Aout(1).currentSettings.display = currentStruct.display.settings; %Aout start as an empty structure. Need to used Aout(1) to give it a size.
Aout.currentSettings.state = currentStruct.state;


% intensityThresh = str2num(get(handles.spc_lifetimeLumLimitTextLow,'String'));

ROIObj = findobj(handles.intensityImgAxes,'Tag','FV_ROI');% start from one axes as now ROIs are duplicated in both axeses. 
ROEObj = findobj(handles.intensityImgAxes, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.intensityImgAxes,'Tag','FV_BGROI');
combinedROIObj = findobj(handles.intensityImgAxes,'Tag','combinedFVROI');


% get ROE info this need to be done before ROI and bgROI as it may alter the BW of
% ROIs.
ROE_Data = get(ROEObj, 'UserData');
if length(ROEObj)>1 %then ROI_UData is a cell
    ROE_Data = cell2mat(ROE_Data);
elseif isempty(ROE_Data)
%     ROE_Data = struct; %this creates an empty struct. may reduce imcompability across files.
    ROE_Data = [];
end

n_roe = length(ROEObj);
totalROEBW = false(siz(1), siz(2));
for j = 1:n_roe %add BW image. This can be removed when saving/loading easily. Will decide later.
    ROE_Data(j).BW = roipoly(ones(siz(1), siz(2)), ROE_Data(j).roi.xi, ROE_Data(j).roi.yi);
    totalROEBW = ROE_Data(j).BW | totalROEBW;
end

% get ROI info
ROI_Data = get(ROIObj, 'UserData');
if length(ROIObj)>1 %then ROI_UData is a cell
    ROI_Data = cell2mat(ROI_Data);
elseif isempty(ROI_Data)
%     ROI_Data = struct; %this creates an empty struct. may reduce imcompability across files.
    ROI_Data = []; % change for now as empty struct tested with isempty is 0
end

n_roi = length(ROIObj);
if n_roi>0
    for j = 1:n_roi %add BW image. This can be removed when saving/loading easily. Will decide later.
        ROI_Data(j).BW = roipoly(ones(siz(1), siz(2)), ROI_Data(j).roi.xi, ROI_Data(j).roi.yi) & ~totalROEBW;
    end
    
    
    Aout.ROINumber = [ROI_Data.number];
    
    [Aout.ROINumber,I] = sort(Aout.ROINumber); % make it sorted so it is easier to handle.
    ROI_Data = ROI_Data(I);
end
    
Aout.ROINumber = horzcat(0, Aout.ROINumber); % in FLIMview, we will put total in the beginning.

% get BGROI info
if ~isempty(bgROIObj)
    bgROI_Data = get(bgROIObj, 'UserData');
    bgROI_Data.BW = roipoly(ones(siz(1), siz(2)), bgROI_Data.roi.xi, bgROI_Data.roi.yi) & ~totalROEBW;
else
%     bgROI_Data = struct; %this creates an empty struct. may reduce imcompability across files.
    bgROI_Data = [];
end

includedZ = zLim(1):zLim(2);
Aout.includedZ = includedZ;

%%%%%%%%%%%%%%%%  Calculate intensity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intensityImg = reshape(currentStruct.image.intensity,siz(1)*siz(2),siz(3));
% compress intensity image form 3D to 2D by combining first and second
% dimension. This helps coding in a simple way.

% intensityImg = currentStruct.image.intensity(:,:,zLim(1):zLim(2));

if ~isempty(bgROIObj) % bg does not change across ROIs.
    intensity_bg = intensityImg(bgROI_Data.BW,includedZ);
    Aout.bgIntensity = mean(intensity_bg, 1)'; % after mean, it is second dimention. make it first dimension.
else
    Aout.bgIntensity(1:length(includedZ),1) = 0;
end

for i = 1:n_roi+1
    if Aout.ROINumber(i) == 0 %zero is total.
        currentBW = ~totalROEBW;
    else
        currentBW = ROI_Data(i-1).BW;
    end
    
    intensityData = intensityImg(currentBW,includedZ);
    intensityData = sort(intensityData,1); %sorting is for calculating max.
%     intensity = intensity(~isnan(intensity));
%     if ~isempty(intensity)
        Aout.avgIntensity(:,i) = mean(intensityData, 1)' - Aout.bgIntensity;
        Aout.maxIntensity(:,i) = mean(intensityData(max([end-4,1]):end,:), 1)' - Aout.bgIntensity;
%     else
%         Aout.intensity(i) = NaN;
%     end
    Aout.roiVol.total(1:length(includedZ), i) = sum(currentBW(:));% note this is per frame
end
Aout.integratedIntensity = Aout.avgIntensity .* Aout.roiVol.total;

%%%%%%%%%%%%  Calculate Lifetime  %%%%%%%%%%%%%%%%
% MPETIntensity = reshape(currentStruct.image.MPETIntensity(:,:,zLim(1):zLim(2)),siz(1)*siz(2),diff(zLim)+1);
Aout.threshForMPET = currentStruct.display.settings.lifetimeLumLimit(1);
I_range = currentStruct.display.settings.spcRangeInd(1):currentStruct.display.settings.spcRangeInd(2);

includedBW = (currentStruct.image.intensity(:,:,includedZ)>=Aout.threshForMPET);

Aout.MPET = zeros(length(includedZ), n_roi+1);%initialize the variable space
for i = 1:n_roi+1
    if Aout.ROINumber(i) == 0 %zero is total.
        currentBW = repmat((~totalROEBW), [1, 1, length(includedZ)]); 
    else
        currentBW = repmat(ROI_Data(i-1).BW, [1, 1, length(includedZ)]); 
    end
    
    currentBW = currentBW & includedBW;
    for j = 1:length(includedZ)
        imageMod = currentStruct.image.imageMod(:,:,:,j);%imageMod is the lifetime curve by pixel e.g. [64, ysize, xsize, zsize]
        imageMod = imageMod(:,currentBW(:,:,j));
        if ~isempty(imageMod)
            Aout.lifetimeCurve{j, i} = sum(imageMod,2);
            Aout.MPET(j, i) = I_range * Aout.lifetimeCurve{j, i}(I_range) / sum(Aout.lifetimeCurve{j, i}(I_range)) * currentStruct.info.datainfo.psPerUnit/1000 - t0;
            
            %%% Important note Haining 2017-06-01
            % Due to limited integration window compared to tau size, MPET is
            % underestimated. Theoretical MPET of a finite window t is given by
            % (tau^2-tau.*(t+tau).*exp(-t/tau)) ./ (tau.*(1-exp(-t/tau))).
            % MPET is therefore off from tau by
            %(tau-(t+tau).*exp(-t/tau)) ./(tau.*(1-exp(-t/tau))).
            % We have an integration window of 48 points (9.4 ns).
            % For fluorescein (LT = 4.2 ns), measured MPET is only 73%
            % For GFP (LT = 2.6), measured MPET is 90% of real value.
            
            Aout.includedPhotonNum(j, i) = sum(Aout.lifetimeCurve{j, i}(I_range));
            Aout.estMPETError(j, i) = Aout.MPET(j, i)/sqrt(Aout.includedPhotonNum(j, i));
            Aout.roiVol.aboveThresh(j, i) = size(imageMod, 2);
        else
            Aout.lifetimeCurve{j, i} = NaN(size(imageMod,1),1);
            Aout.MPET(j, i) = NaN;
            Aout.includedPhotonNum(j, i) = 0;
            Aout.estMPETError(j, i) = NaN;
            Aout.roiVol.aboveThresh(j, i) = 0;
        end
    end
end

% %%%%%%%%%%%%%%%%% Calculate ROI combinations  %%%%%%%%%%%%%%%%%%%%%%
% get combinedFVROI info
combinedROI_Data = get(combinedROIObj, 'UserData');
if length(combinedROIObj)>1 %then ROI_UData is a cell
    combinedROI_Data = cell2mat(combinedROI_Data);
elseif isempty(combinedROI_Data)
    %     combinedROI_Data = struct; %this creates an empty struct. may reduce imcompability across files.
    combinedROI_Data = [];
end

if numel(combinedROIObj)>0
    combinedROINumber = [combinedROI_Data.number];
    [combinedROINumber,I] = sort(combinedROINumber); % make it sorted so it is easier to handle.
    combinedROI_Data = combinedROI_Data(I);
    Aout.ROINumber = horzcat(Aout.ROINumber, combinedROINumber);
    
    for i = 1:length(combinedROIObj)
        
        includedInd = find(ismember(Aout.ROINumber(1:n_roi+1), combinedROI_Data(i).combinedROINumbers));
        currentInd = n_roi+1+i;
        
        currentBW = false(siz(1), siz(2)); % have to do real calculation instead of simple combining the results of individual ROIs as ROIs may overlap
        %     currentBGBW = false(siz);
        for j = includedInd
            currentBW = currentBW | ROI_Data(j-1).BW;
        end
        
        % note: bg does not change across ROIs.
        intensityData = intensityImg(currentBW,includedZ);
        intensityData = sort(intensityData,1); %sorting is for calculating max.
        Aout.avgIntensity(:,currentInd) = mean(intensityData, 1)' - Aout.bgIntensity;
        Aout.maxIntensity(:,currentInd) = mean(intensityData(max([end-4,1]):end,:), 1)' - Aout.bgIntensity;
        Aout.roiVol.total(1:length(includedZ), currentInd) = sum(currentBW(:));% note this is per frame
        
        Aout.integratedIntensity(:,currentInd) = Aout.avgIntensity(:,currentInd) .* Aout.roiVol.total(:,currentInd);
        
        currentBW = repmat(currentBW, [1, 1, length(includedZ)]) & includedBW; % for lifetime, further apply the threshold.
        for j = 1:length(includedZ)
            imageMod = currentStruct.image.imageMod(:,:,:,j);%imageMod is the lifetime curve by pixel e.g. [64, ysize, xsize, zsize]
            imageMod = imageMod(:,currentBW(:,:,j));
            if ~isempty(imageMod)
                Aout.lifetimeCurve{j, currentInd} = sum(imageMod,2);
                Aout.MPET(j, currentInd) = I_range * Aout.lifetimeCurve{j, currentInd}(I_range) / sum(Aout.lifetimeCurve{j, currentInd}(I_range)) * currentStruct.info.datainfo.psPerUnit/1000 - t0;
                Aout.includedPhotonNum(j, currentInd) = sum(Aout.lifetimeCurve{j, currentInd}(I_range));
                Aout.estMPETError(j, currentInd) = Aout.MPET(j, currentInd)/sqrt(Aout.includedPhotonNum(j, currentInd));
                Aout.roiVol.aboveThresh(j, currentInd) = size(imageMod, 2);
            else
                Aout.lifetimeCurve{j, currentInd} = NaN(size(imageMod,1),1);
                Aout.MPET(j, currentInd) = NaN;
                Aout.includedPhotonNum(j, currentInd) = 0;
                Aout.estMPETError(j, currentInd) = NaN;
                Aout.roiVol.aboveThresh(j, currentInd) = 0;
            end
        end
        
        
        %     Aout.roiVol.total(currentInd) = sum(Aout.roiVol.total(includedInd));
        %     Aout.roiVol.aboveThresh(currentInd) = sum(Aout.roiVol.aboveThresh(includedInd));
        %     Aout.bgIntensity(currentInd) = sum(Aout.bgIntensity(includedInd).*Aout.roiVol.total(includedInd)) / Aout.roiVol.total(currentInd);
        %
        %     Aout.integratedIntensity(currentInd) =  sum(Aout.integratedIntensity(includedInd));
        %     Aout.avgIntensity(currentInd) =  Aout.integratedIntensity(currentInd) / Aout.roiVol.total(currentInd);
        %     Aout.maxIntensity(currentInd) =  max(Aout.maxIntensity(includedInd));
        %
        %     Aout.lifetimeCurve{currentInd} = sum(cat(2, Aout.lifetimeCurve{includedInd}), 2);
        %     Aout.MPET(currentInd) = I_range * Aout.lifetimeCurve{currentInd}(I_range) / sum(Aout.lifetimeCurve{currentInd}(I_range)) * currentStruct.info.datainfo.psPerUnit/1000 - t0;
        %     Aout.includedPhotonNum(currentInd) = sum(Aout.lifetimeCurve{currentInd}(I_range));
        %     Aout.estMPETError(currentInd) = Aout.MPET(currentInd)/sqrt(Aout.includedPhotonNum(currentInd));
        % %     Aout.lifetimeCurveFit(currentInd).fit = [];
    end
end

% %%%%%%%%%%%%%%%%%  Fitting and binding fraction  %%%%%%%%%%%%%%%%%%%%
% 
% if isfield(FV_img.currentHandles,'spc_newRoi')
%     currentFcn = 1;
% elseif isfield(FV_img.currentHandles,'ss_timeCourse')
%     currentFcn = 2;
% elseif isfield(FV_img.currentHandles,'plotFcn')
%     currentFcn = 3;
% end
% ss_setupVariableField('ss_lifetimeFittingGUI', handles.spc_stack);
% FV_img.currentHandles = guihandles(handles.spc_stack);
% UserData = get(handles.spc_lifetimeFunctions,'UserData');
% ss_setPara(handles.spc_lifetimeFunctions,UserData);
% handles = FV_img.currentHandles;
% try
%     ss_resetLifetimeRange(FV_img.currentHandles);        
%     range = FV_img.spc.fit.range;
%     t = [range(1):range(2)]*FV_img.spc.datainfo.psPerUnit/1000;
%     for i = 1:length(Aout.roi)
%         if get(handles.bgSubtractionOpt,'value')
%             bg = FV_img.lastCalcROI.intensity_bg(i) / length(FV_img.lastCalcROI.lifetimeCurve{i})...
%                 * FV_img.lastCalcROI.pixelsForLifetime(i);
% %             Aout.lifetimeCurveFit(i).backgroundSubtraction = 1;
%         else
%             bg = 0;
% %             Aout.lifetimeCurveFit(i).backgroundSubtraction = 1;
%         end
%         lifetime = Aout.lifetimeCurve{i}(range(1):range(2)) - bg;
% %         [x, fit, betahat,converge] = ss_fitexp2gauss(t,lifetime);
% %         if ~converge
%             set(handles.spc_pop1,'String',num2str(max(lifetime)/2));%for better fitting init parameters
%             set(handles.spc_pop2,'String',num2str(max(lifetime)/2));%for better fitting init parameters
%             [x, fit, betahat,converge] = ss_fitexp2gauss(t,lifetime);
% %         end
%         Aout.lifetimeCurveFit(i).fit.xdata = x;
%         Aout.lifetimeCurveFit(i).fit.ydata = fit;
%         Aout.lifetimeCurveFit(i).fit.t = t;
%         Aout.lifetimeCurveFit(i).fit.beta = betahat;
%         Aout.lifetimeCurveFit(i).fit.beta([2,4:6]) = Aout.lifetimeCurveFit(i).fit.beta([2,4:6])*FV_img.spc.datainfo.psPerUnit/1000;
%         Aout.lifetimeCurveFit(i).fit.fix.tau1 = get(handles.spc_fixTau1, 'Value');
%         Aout.lifetimeCurveFit(i).fit.fix.tau2 = get(handles.spc_fixTau2, 'Value');
%         Aout.lifetimeCurveFit(i).fit.fix.deltaPeak = get(handles.spc_fixDeltaPeak, 'Value');
%         Aout.lifetimeCurveFit(i).fit.fix.beta6 = get(handles.spc_fixDeltaPeak, 'Value');
%         Aout.lifetimeCurveFit(i).fit.method = 'Double Exp';
%         Aout.lifetimeCurveFit(i).fit.converge = converge;
%         if ~converge
%             disp(['Fitting for ',fname, ' ROI#',num2str(i), ' did not converge!']);
%         end
%     end
%     for i = 1:length(Aout.roi) %to calculate the binding ratio for small ROIs
%         beta = Aout.lifetimeCurveFit(i).fit.beta;
%         Aout.fitPct2(i) = beta(3)/(beta(1)+beta(3));
%         Aout.calcPct2(i) = ss_calcBindingFraction(Aout.lifetime(i), Aout.lifetime(end), Aout.lifetimeCurveFit(end).fit.beta);
%     end
% end
% if currentFcn == 1
%     ss_setupVariableField('ss_generalControlGUI', handles.spc_stack);
%     FV_img.currentHandles = guihandles(handles.spc_stack);
%     UserData = get(handles.spc_generalFunctions,'UserData');
%     ss_setPara(handles.spc_generalFunctions,UserData);
% elseif currentFcn == 2
%     ss_setupVariableField('ss_lifetimeFittingGUI', handles.spc_stack);
%     FV_img.currentHandles = guihandles(handles.spc_stack);
%     UserData = get(handles.spc_lifetimeFunctions,'UserData');
%     ss_setPara(handles.spc_lifetimeFunctions,UserData);
%     ss_resetLifetimeRange(FV_img.currentHandles);        
% elseif currentFcn == 3
%     ss_setupVariableField('ss_plottingFcnGUI', handles.spc_stack);
%     FV_img.currentHandles = guihandles(handles.spc_stack);
%     UserData = get(handles.spc_plotControls,'UserData');
%     ss_setPara(handles.spc_plotControls,UserData);
% end
% 
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555

% final information and processing
if ~isempty(ROI_Data) % it can be empty and no 'BW' field.
    Aout.allROIInfo.ROI = rmfield(ROI_Data,'BW'); % this reduce file size by 70-80%
else
    Aout.allROIInfo.ROI = ROI_Data; % this should be empty
end
if ~isempty(bgROI_Data)
    Aout.allROIInfo.bgROI = rmfield(bgROI_Data, 'BW');
else
    Aout.allROIInfo.bgROI = bgROI_Data; % this should be empty
end
if ~isempty(ROE_Data)
    Aout.allROIInfo.ROE = rmfield(ROE_Data, 'BW');
else
    Aout.allROIInfo.ROE = ROE_Data; % this should be empty
end
Aout.allROIInfo.combinedROI = combinedROI_Data;
Aout.allROIInfo.imageSize = siz; % as BW is removed. this is needed to recreate BW as needed.

Aout.roiVol.pctIncluded = Aout.roiVol.aboveThresh ./ Aout.roiVol.total;

Aout.timestr = currentStruct.info.datainfo.triggerTime;
Aout.filename = fname;


%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~(exist(fullfile(filepath,'Analysis'))==7)
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end


analysisNumber = currentStruct.state.analysisNum.value;

save(fullfile(filepath,'Analysis',[filename,'_FVFrameAnalysis_A',num2str(analysisNumber),'.mat']), 'Aout');
assignin('base','FVFrameAnalysis',Aout);

FV_img.(currentStructName).lastAnalysis.frameAnalysis = Aout;

FV_updateInfo(handles);

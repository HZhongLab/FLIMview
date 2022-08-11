function Aout = FV_executeCalcROI(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

t0 = currentStruct.display.settings.t0;
zLim = currentStruct.display.settings.zLimit;

fname = get(handles.currentFileName,'String');
[filepath,filename,fExt] = fileparts(fname);

siz = size(currentStruct.image.intensity);

% initialized Aout so that the structure is consistent across files.
Aout = struct('currentSettings', struct('display', struct, 'state', struct), 'allROIInfo', [], 'bgIntensity', [], 'ROINumber',[],...
    'avgIntensity', [], 'integratedIntensity', [], 'maxIntensity', [], 'MPET', [], 'threshForMPET', [], 'includedPhotonNum', [],...
    'estMPETError', [], 'roiVol', struct('total', [], 'aboveThresh', [], 'pctIncluded', []), 'lifetimeCurve', {},...
    'lifetimeCurveFit', struct, 'bindingPct', struct, 'timestr', '', 'filename', '');
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


%%%%%%%%%%%%%%%%  Calculate intensity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intensityImg = reshape(currentStruct.image.intensity(:,:,zLim(1):zLim(2)),siz(1)*siz(2),diff(zLim)+1);
% compress intensity image form 3D to 2D by combining first and second
% dimension. This helps coding in a simple way.

% intensityImg = currentStruct.image.intensity(:,:,zLim(1):zLim(2));

for i = 1:n_roi+1
    if Aout.ROINumber(i) == 0 %zero is total.
        currentBW = ~totalROEBW;
    else
        currentBW = ROI_Data(i-1).BW;
    end
    avg_intensity = zeros(1, size(intensityImg,2));
    for j = 1:size(intensityImg,2)
        im = intensityImg(:,j);
        avg_intensity(j) = mean(im(currentBW));% it will give NaN if currentBW is all zero.
    end

    if Aout.ROINumber(i) ~= 0 %zero is total. For each real ROI, find its z.      
        zi = find(avg_intensity==max(avg_intensity));
        zi = zi(1);
        if zi+1 <= size(intensityImg,2)
            z_end = zi+1;
        else
            z_end = zi;
        end
        if zi-1 >= 1
            z_start = zi-1;
        else
            z_start = zi;
        end
        includedZ = z_start:z_end;
        ROI_Data(i-1).includedZ = includedZ + zLim(1) - 1;
    else
        includedZ = 1:size(intensityImg,2);
    end
    
    if ~isempty(bgROIObj)
        intensity_bg = intensityImg(bgROI_Data.BW,includedZ);
        intensity_bg = intensity_bg(:);
%         if ~isempty(intensity_bg)
            Aout.bgIntensity(i) = mean(intensity_bg);
%         else
%             Aout.bgIntensity(i) = 0;
%         end
    else
        Aout.bgIntensity(i) = 0;
    end
    
    intensity = intensityImg(currentBW,includedZ);
    intensity = sort(intensity(:));% sort the pixel values so that average of a few pixels are possible for maxIntensity.
%     intensity = intensity(~isnan(intensity));
%     if ~isempty(intensity)
        Aout.avgIntensity(i) = mean(intensity) - Aout.bgIntensity(i);
%         Aout.maxIntensity(i) = max(intensity) - Aout.bgIntensity(i);
        Aout.maxIntensity(i) = mean(intensity(max([end-4,1]):end)) - Aout.bgIntensity(i);
%     else
%         Aout.intensity(i) = NaN;
%     end
    Aout.roiVol.total(i) = length(intensity);
end
Aout.integratedIntensity = Aout.avgIntensity .* Aout.roiVol.total;

%%%%%%%%%%%%  Calculate Lifetime  %%%%%%%%%%%%%%%%
% MPETIntensity = reshape(currentStruct.image.MPETIntensity(:,:,zLim(1):zLim(2)),siz(1)*siz(2),diff(zLim)+1);
Aout.threshForMPET = currentStruct.display.settings.lifetimeLumLimit(1);
I_range = currentStruct.display.settings.spcRangeInd(1):currentStruct.display.settings.spcRangeInd(2);

includedBW = (currentStruct.image.intensity>=Aout.threshForMPET);

for i = 1:n_roi+1
    currentBW = false(siz);
    if Aout.ROINumber(i) == 0 %zero is total.
        includedZ = zLim(1):zLim(2);
        currentBW(:,:,includedZ) = repmat((~totalROEBW), [1, 1, length(includedZ)]); 
    else
        includedZ = ROI_Data(i-1).includedZ;
        currentBW(:,:,includedZ) = repmat(ROI_Data(i-1).BW, [1, 1, length(includedZ)]); 
    end
    
    currentBW = currentBW & includedBW;
    imageMod = currentStruct.image.imageMod(:,currentBW);%imageMod is the lifetime curve by pixel e.g. [64, ysize, xsize, zsize]

    if ~isempty(imageMod)
        Aout.lifetimeCurve{i} = sum(imageMod,2);
        Aout.MPET(i) = I_range * Aout.lifetimeCurve{i}(I_range) / sum(Aout.lifetimeCurve{i}(I_range)) * currentStruct.info.datainfo.psPerUnit/1000 - t0;
        
        %%% Important note Haining 2017-06-01
        % Due to limited integration window compared to tau size, MPET is
        % underestimated. Theoretical MPET of a finite window t is given by
        % (tau^2-tau.*(t+tau).*exp(-t/tau)) ./ (tau.*(1-exp(-t/tau))).
        % MPET is therefore off from tau by 
        %(tau-(t+tau).*exp(-t/tau)) ./(tau.*(1-exp(-t/tau))). 
        % We have an integration window of 48 points (9.4 ns). 
        % For fluorescein (LT = 4.2 ns), measured MPET is only 73% 
        % For GFP (LT = 2.6), measured MPET is 90% of real value.
        
        Aout.includedPhotonNum(i) = sum(Aout.lifetimeCurve{i}(I_range));
        Aout.estMPETError(i) = Aout.MPET(i)/sqrt(Aout.includedPhotonNum(i));
        Aout.roiVol.aboveThresh(i) = size(imageMod, 2);
    else
        Aout.lifetimeCurve{i} = NaN(size(imageMod,1),1);
        Aout.MPET(i) = NaN;
        Aout.includedPhotonNum(i) = 0;
        Aout.estMPETError(i) = NaN;
        Aout.roiVol.aboveThresh(i) = 0;
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
        
        currentBW = false(siz); % have to do real calculation instead of simple combining the results of individual ROIs as ROIs may overlap
        %     currentBGBW = false(siz);
        for j = includedInd
            ROIBW = false(siz);
            ROIBW(:,:,ROI_Data(j-1).includedZ) = repmat(ROI_Data(j-1).BW, [1, 1, length(ROI_Data(j-1).includedZ)]); %j-1 because in ROINumber, first one is ROI#0
            currentBW = currentBW | ROIBW;
        end
        includedZForBG = unique(cat(2, ROI_Data(includedInd-1).includedZ));
        
        % in principle, one may want to do a weighted bg based on the number of pixels included in that plane. But for simplicity,
        % we are doing a simple bg calculation here.
        if ~isempty(bgROIObj)
            bgROIBW = false(siz);
            bgROIBW(:,:,includedZForBG) = repmat(bgROI_Data.BW, [1, 1, length(includedZForBG)]); %j-1 because in ROINumber, first one is ROI#0
            %         Aout.bgIntensity(currentInd) = mean(currentStruct.image.intensity(bgROIBW));
            
            % try weighted bg calculation:
            intensityImg = currentStruct.image.intensity;
            intensityImg(~bgROIBW) = 0;
            bgAlongZ = squeeze(sum(sum((intensityImg), 1),2)) / sum(bgROI_Data.BW(:));
            ROIPixelAlongZ = squeeze(sum(sum((currentBW), 1),2));
            Aout.bgIntensity(currentInd) = sum(bgAlongZ .* ROIPixelAlongZ) / sum(ROIPixelAlongZ);
        else
            Aout.bgIntensity(currentInd) = 0;
        end
        
        intensityData = currentStruct.image.intensity(currentBW);
        Aout.avgIntensity(currentInd) = mean(intensityData) - Aout.bgIntensity(currentInd);
        Aout.maxIntensity(currentInd) = max(intensityData) - Aout.bgIntensity(currentInd);
        
        Aout.roiVol.total(currentInd) = length(intensityData);
        Aout.integratedIntensity(currentInd) = Aout.avgIntensity(currentInd) .* Aout.roiVol.total(currentInd);
        
        currentBW = currentBW & includedBW; % for lifetime, further apply the threshold.
        imageMod = currentStruct.image.imageMod(:,currentBW);%imageMod is the lifetime curve by pixel e.g. [64, ysize, xsize, zsize]
        
        if ~isempty(imageMod)
            Aout.lifetimeCurve{currentInd} = sum(imageMod,2);
            Aout.MPET(currentInd) = I_range * Aout.lifetimeCurve{currentInd}(I_range) / sum(Aout.lifetimeCurve{currentInd}(I_range)) * currentStruct.info.datainfo.psPerUnit/1000 - t0;
            Aout.includedPhotonNum(currentInd) = sum(Aout.lifetimeCurve{currentInd}(I_range));
            Aout.estMPETError(currentInd) = Aout.MPET(currentInd)/sqrt(Aout.includedPhotonNum(currentInd));
            Aout.roiVol.aboveThresh(currentInd) = size(imageMod, 2);
        else
            Aout.lifetimeCurve{currentInd} = NaN(size(imageMod,1),1);
            Aout.MPET(currentInd) = NaN;
            Aout.includedPhotonNum(currentInd) = 0;
            Aout.estMPETError(currentInd) = NaN;
            Aout.roiVol.aboveThresh(currentInd) = 0;
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
spcRange = [str2double(currentStruct.state.lifetimeSPCRangeStrLow.string),...
    str2double(currentStruct.state.lifetimeSPCRangeStrHigh.string)];
spcRangeInd = round(spcRange*1000/currentStruct.info.datainfo.psPerUnit);

t = (spcRangeInd(1):spcRangeInd(2))*currentStruct.info.datainfo.psPerUnit/1000;

for i = 1:length(Aout.ROINumber)
    intensity = Aout.lifetimeCurve{i}(spcRangeInd(1):spcRangeInd(2));
    switch currentStruct.state.lifetimeFittingOpt.value
        case 1 % fitting with single
            Aout.lifetimeCurveFit(i) = FV_fitBySingleExp(t, intensity, handles); % will only use gaussian to simulate the prf. for using a real prf, checkout ss_fitBySingle
        case 2
            Aout.lifetimeCurveFit(i) = FV_fitByDoubleExp(t, intensity, handles);
        otherwise
    end
    if ~Aout.lifetimeCurveFit(i).converge
        disp(['Fitting for ',filename, ' ROI#',num2str(Aout.ROINumber(i)), ' did not converge!']);
    end
end

for i = 1:length(Aout.ROINumber) %to calculate the binding ratio for small ROIs
    beta = Aout.lifetimeCurveFit(i).beta;
    Aout.bindingPct.fit(i) = beta(3)/(beta(1)+beta(3));
    Aout.bindingPct.calc(i) = FV_calcBindingFraction(Aout.MPET(i), Aout.MPET(1), Aout.lifetimeCurveFit(1).beta);
end

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

try
    Aout.timestr = currentStruct.info.datainfo.triggerTime;
catch
    d = h_dir(fname);
    Aout.timestr = datestr(d.datenum);
end
    
Aout.filename = fname;

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~(exist(fullfile(filepath,'Analysis'))==7)
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end


analysisNumber = currentStruct.state.analysisNum.value;

save(fullfile(filepath,'Analysis',[filename,'_FVROI_A',num2str(analysisNumber),'.mat']), 'Aout');
assignin('base','calcFVROI',Aout);

FV_img.(currentStructName).lastAnalysis.calcFVROI = Aout;

FV_updateInfo(handles);

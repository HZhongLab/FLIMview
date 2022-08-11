function grpData = FV_checkZPos(handles)

% this is to check the z position of individual ROIs relative to the mean
% z of avg ROI to see whether there may be errors in determining z. 
%
% some codes are recycled from FV_plotGroupFcn, so may not be the cleanest.


% global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

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

currentROIInd = 2:length(grpData(1).ROINumber); % index 1 is ROI 0

zdata = zeros(length(grpData), length(currentROIInd));
for i = 1:length(grpData)
    for j = 1:length(grpData(i).ROINumber)-1
        zdata(i, j) = mean(grpData(i).allROIInfo.ROI(j).includedZ);
    end
end

if length(currentROIInd)<=2
    display('ROI numbers <= 2; please visually inspect');
else
    avgROIZ = mean(zdata,2);
    expectedZData = zeros(size(zdata));
    for j = 1:size(zdata,2)
        currentZ = zdata(:,j);
        expectedZ =  avgROIZ - mean(avgROIZ) + mean(currentZ);
        expectedZData(:,j) = expectedZ;
    end
    
    % create the entire expectedZData before checking so that we can go
    % from the largest first.
    
    thresh = 2.1;
    diffZData = abs(expectedZData - zdata);
    [maxDiff, ind] = max(diffZData(:));
    k = 1;
    zdata2 = zdata;
    zdata3 = zdata;
    avgROIZ2 = avgROIZ;
    while maxDiff > thresh
        [I(k), J(k)] = ind2sub(size(zdata), ind(1));
        if J(k)>1
            iii = 1;
        elseif J(k)==1
            iii = 1;
        end
        % correct for expectedZData
        zdata2(I(k), J(k)) = nan;
%   above simple way can cause problem Try the method below to predict the
%   value for zData(I(k), J(k)).
        currentZ = zdata3(:,J(k));
        zdata3(I(k), J(k)) = mean(zdata3(I(k), (1:size(zdata3,2))~=J(k))) - ...
            mean(avgROIZ2((1:length(avgROIZ2))~=I(k))) + mean(currentZ((1:length(avgROIZ2))~=I(k)));
        avgROIZ2 = nanmean(zdata3,2);
        for j = 1:size(zdata,2) %update expectedZData
            currentZ = zdata3(:,j);
            expectedZ =  avgROIZ2 - nanmean(avgROIZ2(~isnan(currentZ))) + nanmean(currentZ(~isnan(currentZ)));
            expectedZData(:,j) = expectedZ;
%             if any(isnan(expectedZ(:)))
%                 kkk = 1;
%             end
        end
        diffZData = abs(expectedZData - zdata2);
        [maxDiff, ind] = max(diffZData(:));
        k = k + 1;
    end
    
    diffZData = abs(expectedZData - zdata);
    ind = find(diffZData>thresh); 
    for i = 1:length(ind)
    
        [I, J] = ind2sub(size(diffZData), ind(i));
        
        filename = currentStruct.activeGroup.groupFiles(I).fname;
        [pname, fname, fExt] = fileparts(filename);% fname is filename without extention.        
        dataFName = [fname,'_FVROI_A',num2str(analysisNumber),'.mat'];
   
        disp(['ROI#', num2str(J), ' in ', dataFName, ' may have error: expected Z: ', num2str(round(expectedZData(I, J)*10)/10),...
            '   current Z:', num2str(round(zdata(I, J)*10)/10)]);
    end
    disp(' ')
    disp(['Totol # of potential errors = ', num2str(length(ind))])
    disp(' ')
end
        
    
    
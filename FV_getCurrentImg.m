function FV_getCurrentImg(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

% siz = size(currentStruct.image.intensity);
zLim = currentStruct.display.settings.zLimit;

if currentStruct.state.intensityImgOpt.value
    intensity = currentStruct.image.MPETIntensity;
else
    intensity = currentStruct.image.intensity;
end

switch currentStruct.state.lifetimeImgDisplayOpt.value
    case 1
        activityMap = currentStruct.image.MPETMap;
    case 2   
        if ~isfield(h_spc.spc,'bindingFractionMap')
            ss_calcBindingFractionMap;
        end
        activityMap = h_spc.spc.bindingFractionMap.map;
    case 3 % deltaMPET
        activityMap = currentStruct.image.MPETMap - currentStruct.display.settings.LT0;
    case 4 % deltaMPET
        activityMap = (currentStruct.image.MPETMap - currentStruct.display.settings.LT0) / currentStruct.display.settings.LT0;
end

% dispAxes = get(handles.viewingAxis,'Value');
switch currentStruct.state.viewingAxis.value
    case {1, 4, 7, 10}
        viewingAxis = 3;
        [intensityImg,I] = max(intensity(:,:,zLim(1):zLim(2)),[],3);
        I2 = reshape(((I(:)-1)*numel(I) + (1:numel(I))'),size(I));
        temp = activityMap(:,:,zLim(1):zLim(2));
        activityImg = temp(I2);
    case {2, 5, 8, 11}
        viewingAxis = 1;
        [intensityImg,I] = max(  permute(intensity(zLim(1):zLim(2),:,:),  [3,2,1])   ,[],3);
        I2 = reshape(((I(:)-1)*numel(I) + (1:numel(I))'),size(I));
        temp = permute(activityMap(zLim(1):zLim(2),:,:),[3,2,1]);
        activityImg = temp(I2);
    case {3, 6, 9, 12}
        viewingAxis = 2;
        [intensityImg,I] = max(  permute(intensity(:,zLim(1):zLim(2),:),  [3,1,2])   ,[],3);
        I2 = reshape(((I(:)-1)*numel(I) + (1:numel(I))'),size(I));
        temp = permute(activityMap(:,zLim(1):zLim(2),:),[3,1,2]);
        activityImg = temp(I2);
end

% filter_on = get(handles.spc_smoothImage,'Value');

switch currentStruct.state.filterOpt.value
    case 2 % 'no filter'
        f = [];
%     case 2 % 'old'
% %         sigma = 1;
%         f = [0.07 0.12 0.07; 0.12 0.24 0.12; 0.07 0.12 0.07];
    case {1, 3} % 'GF, s=1' or 'default GF'
        sigma = 1;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 4 % 'GF, s=1.5'
        sigma = 1.5;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 5 % 'GF, s=2'
        sigma = 2;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 6 % 'GF, s=3'
        sigma = 3;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    case 7 % 'GF, s=5'
        sigma = 5;
        f = fspecial('gaussian', 2*(sigma+1)+1, sigma);
    otherwise
        f = [];
end

intensityImg = double(intensityImg); % make it double here. Otherwise may create calculation error in other part of program.

if ~isempty(f)
%     f = ones(3)/9;
    currentStruct.display.intensityImg = filter2(f, intensityImg);
    
% Below this is the old way to filter lifetime image. It allows pixels with low number of photons
% have equal weight as pixels with high number of photons.
%     currentStruct.display.activityImg = filter2(f, activityImg); 

% try new way: Tested: This is much better especially if using larger gaussian.
%     currentStruct.display.activityImg = filter2(f, intensityImg.*activityImg)./currentStruct.display.intensityImg;
    
% try this: implement lum control here: 
% Keep for now. Very minimal visual difference from above.
    thresh = currentStruct.display.settings.lifetimeLumLimit(1);
    intensityImg(intensityImg<thresh) = 0;
    currentStruct.display.activityImg = filter2(f, intensityImg.*activityImg)./filter2(f,intensityImg);
else
    currentStruct.display.intensityImg = intensityImg; % make the data type consistent. if not filter it would be uint16.
    currentStruct.display.activityImg = activityImg;
end

FV_img.(currentStructName).display = currentStruct.display;

% ss_intensityQuality(handles);
% ss_lifetimeQuality(handles);

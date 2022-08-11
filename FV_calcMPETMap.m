function  FV_calcMPETMap(handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

t0 = currentStruct.display.settings.t0;
I = currentStruct.display.settings.spcRangeInd(1):currentStruct.display.settings.spcRangeInd(2);
    
siz = size(currentStruct.image.intensity);
if numel(siz)<3 %e.g. in _max files.
    siz(3) = 1;
end
currentStruct.image.MPETMap = zeros(siz);
currentStruct.image.MPETIntensity = zeros(siz, 'uint16');
% weighted_sum = I * double(currentStruct.image.imageMod(I,:));
% 
% total_weight = sum(currentStruct.image.imageMod(I,:),1);
% currentStruct.image.MPETIntensity(:) = total_weight;
% 
% bw = (total_weight>0);%this should reduce the amount of calculation effort.
% currentStruct.image.MPETMap(bw) = weighted_sum(bw)./total_weight(bw)*currentStruct.info.datainfo.psPerUnit/1000 - t0;

for j = 1:siz(3)
    currentImageMod = currentStruct.image.imageMod(:,:,:,j);
    weighted_sum = I * single(currentImageMod(I,:));

    total_weight = sum(currentImageMod(I,:),1);
    currentMPETIntensity = currentStruct.image.MPETIntensity(:,:,j);
    currentMPETIntensity(:) = total_weight;
    currentStruct.image.MPETIntensity(:,:,j) = currentMPETIntensity;

    bw = (total_weight>0);%this should reduce the amount of calculation effort.
    currentMPETMap = currentStruct.image.MPETMap(:,:,j);
    currentMPETMap(bw) = weighted_sum(bw)./total_weight(bw)*currentStruct.info.datainfo.psPerUnit/1000 - t0;
    currentStruct.image.MPETMap(:,:,j) = currentMPETMap;
end

FV_img.(currentStructName) = currentStruct;


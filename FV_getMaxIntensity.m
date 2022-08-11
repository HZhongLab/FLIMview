function [maxIntensity, sliderStep] = FV_getMaxIntensity(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

maxIntensity = max(currentStruct.image.intensity(:));

%some fo this is unnessary but just copied from the counterpart of h_imstack3
if isempty(maxIntensity) || maxIntensity < 1 
    maxIntensity = 1;
    sliderStep = [0.01, 0.1];
elseif maxIntensity < 2^8
    maxIntensity = 2^8 - 1;
    sliderStep = [1/maxIntensity, 10/maxIntensity];
elseif maxIntensity < 2^10
    maxIntensity = 2^10 - 1;
    sliderStep = [2/maxIntensity, 20/maxIntensity];
elseif maxIntensity < 2^11
    maxIntensity = 2^11 - 1;
    sliderStep = [3/maxIntensity, 50/maxIntensity];
elseif maxIntensity < 2^12
    maxIntensity = 2^12 - 1;
    sliderStep = [5/maxIntensity, 100/maxIntensity];
elseif maxIntensity < 2^13
    maxIntensity = 2^13 - 1;
    sliderStep = [10/maxIntensity, 200/maxIntensity];
elseif maxIntensity < 2^14
    maxIntensity = 2^14 - 1;
    sliderStep = [20/maxIntensity, 200/maxIntensity];
else
    maxIntensity = 2^16 - 1;
    sliderStep = [100/maxIntensity, 1000/maxIntensity];
end
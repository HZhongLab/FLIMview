function [minLifetime, maxLifetime] = FV_getLifetimeLimitBoundary(handles)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

switch currentStruct.state.lifetimeImgDisplayOpt.value 
    case 1 % normal lifetime/MPET
        maxLifetime = 6; % as repeat is 12.5 ns so it is hard to measure anything more than 6 ns lifetime.
        minLifetime = 0;
    case 2 % 2 is binding fraction
        maxLifetime = 1.05;
        minLifetime = -0.05;
    case 3 % deltaMPET
        maxLifetime = 2; % as repeat is 12.5 ns so it is hard to measure anything more than 6 ns lifetime.
        minLifetime = -2;        
    case 4 % tentatively 3 is deltaMPETOverMPET
        maxLifetime = 5; % this is arbiturary. May change to better way in the future.
        minLifetime = -1;
end
function FV_autoPosition(handles)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

ROIObj = findobj(handles.intensityImgAxes,'Tag','FV_ROI');
ROEObj = findobj(handles.intensityImgAxes, 'Tag', 'FV_ROE');
bgROIObj = findobj(handles.intensityImgAxes,'Tag','FV_BGROI');
% note: we will not move combined ROI.
allROIObj = vertcat(ROIObj, ROEObj, bgROIObj);

newImg = FV_img.(currentStructName).display.intensityImg;
reference = FV_img.(currentStructName).display.previousIntensityImg;
siz = size(newImg);
saveUserDataFlag = 0;


if ismember(currentStruct.state.autoPosOpt.value, [1 2 3 5 6 7 8]) % move.   
    if sum(reference(:)) > 0 % for the first image opened, reference is all zero
        UData = get(allROIObj,'UserData'); % do it here because in centering, it has to be redone anyway.
        if ~isempty(UData)
            if iscell(UData)
                UData = cell2mat(UData);
                FV_img.(currentStructName).internal.previousROIUserData = UData;
                saveUserDataFlag = 1;
            end
        else
            return; % if not ROI, just return.
        end

        
        %%%%% below is modified from h_twoStepAutoPosition2
        if ~isempty(reference)
            offset = h_corr(reference,newImg);
            n_roi = length(allROIObj);
            totalOffset = zeros(n_roi, 2);
            for i = 1:n_roi
                if (strcmpi(UData(i).ROIType, 'FV_ROI') || strcmpi(UData(i).ROIType, 'FV_ROE'))...
                        && ismember(currentStruct.state.autoPosOpt.value, [3 7 8]) % only do two step move is specified
                    %         UserData = get(allROIObj(i),'UserData');
                    pos = [min(UData(i).roi.xi),min(UData(i).roi.yi),max(UData(i).roi.xi)-min(UData(i).roi.xi),max(UData(i).roi.yi)-min(UData(i).roi.yi)];
                    
                    localRefx1 = round(max(pos(1) - pos(3),1));% go one fold on each side.
                    localRefx2 = round(min(pos(1) + 2 * pos(3),size(reference,2)));
                    localRefy1 = round(max(pos(2) - pos(4),1));
                    localRefy2 = round(min(pos(2) + 2 * pos(4),size(reference,1)));
                    
                    %         pos(1) = pos(1) + offset(2);
                    %         pos(2) = pos(2) + offset(1);
                    localImgx1 = localRefx1 + offset(2);
                    localImgx2 = localRefx2 + offset(2);
                    localImgy1 = localRefy1 + offset(1);
                    localImgy2 = localRefy2 + offset(1);
                    
                    % Correct the local frame that could be out of image
                    dx = min([localRefx1,localImgx1,0.5]) - 0.5;
                    localRefx1 = round(localRefx1 - dx);
                    %             localRefx2 = round(localRefx2 - dx);
                    localImgx1 = round(localImgx1 - dx);
                    %             localImgx2 = round(localImgx2 - dx);
                    
                    dy = min([localRefy1,localImgy1,0.5]) - 0.5;
                    localRefy1 = round(localRefy1 - dy);
                    %             localRefy2 = round(localRefy2 - dy);
                    localImgy1 = round(localImgy1 - dy);
                    %             localImgy2 = round(localImgy2 - dy);
                    
                    % Correct the local frame that could be out of image
                    dx = max([localRefx2,localImgx2,siz(2)]) - (siz(2));
                    %             localRefx1 = round(localRefx1 - dx);
                    localRefx2 = round(localRefx2 - dx);
                    %             localImgx1 = round(localImgx1 - dx);
                    localImgx2 = round(localImgx2 - dx);
                    
                    dy = max([localRefy2,localImgy2,siz(1)]) - (siz(1));
                    %             localRefy1 = round(localRefy1 - dy);
                    localRefy2 = round(localRefy2 - dy);
                    %             localImgy1 = round(localImgy1 - dy);
                    localImgy2 = round(localImgy2 - dy);
                    
                    localRef = reference(localRefy1:localRefy2,localRefx1:localRefx2);
                    localImg = newImg(localImgy1:localImgy2,localImgx1:localImgx2);
                    try % can be error if ROI is small.
                        local_offset = h_corr(localRef,localImg);
                    catch
                        local_offset = [0 0];
                    end
                    
                    totalOffset(i,1) = offset(1)+local_offset(1);
                    totalOffset(i,2) = offset(2)+local_offset(2);
                else
                    totalOffset(i,:) = offset; %don't do local offset for bg as it can go crazy due to no feature.
                end
                
                FV_moveROI(allROIObj(i),[totalOffset(i,2),totalOffset(i,1)]); %second column is x, first column is y.
                
            end
        end
    end
end

if ismember(currentStruct.state.autoPosOpt.value, [4 5 6 7 8]) % center on gravity.
    UData = get(ROIObj,'UserData'); % re-get ROI data as ROI may have move. Also, only do ROIs
    if ~isempty(UData)
        if iscell(UData)
            UData = cell2mat(UData);
            if saveUserDataFlag == 0 % only save if it has not been previous saved.
                FV_img.(currentStructName).internal.previousROIUserData = UData;
            end
        end
    else
        return; % if not ROI, just return.
    end
    n_roi = length(ROIObj);
    refUData = FV_img.(currentStructName).internal.previousROIUserData(1:n_roi);
    for i = 1:n_roi %add BW image. This can be removed when saving/loading easily. Will decide later.
        if ismember(currentStruct.state.autoPosOpt.value, [6, 8]) % lock offset to center of mass.
            refBW = roipoly(ones(siz(1), siz(2)), refUData(i).roi.xi, refUData(i).roi.yi);
            refROIImg = reference.*double(refBW);
            [xCenter_BW1, yCenter_BW1] = h_calculateCenterOfMass(refBW);
            [xCenter_Intensity1, yCenter_Intensity1] = h_calculateCenterOfMass(refROIImg);
            previousOffset = [xCenter_Intensity1 - xCenter_BW1, yCenter_Intensity1 - yCenter_BW1];% note: x, y here. y, x above in offset.
        else
            previousOffset = [0 0]; % this is center to center-of-mass.
        end

        flag = 0;
        j = 0;
        while flag==0
            BW = roipoly(ones(siz(1), siz(2)), UData(i).roi.xi, UData(i).roi.yi);
            ROIImg = newImg.*double(BW);
            [xCenter_BW, yCenter_BW] = h_calculateCenterOfMass(BW);
            [xCenter_Intensity, yCenter_Intensity] = h_calculateCenterOfMass(ROIImg);
            offset = [xCenter_Intensity - xCenter_BW, yCenter_Intensity - yCenter_BW] - previousOffset;% note: x, y here. y, x above in offset.
            disp(offset)
            if any(isnan(offset))
                iii = 1;
            end
            UData(i).roi.xi = UData(i).roi.xi + offset(1);
            UData(i).roi.yi = UData(i).roi.yi + offset(2);
            if sum(offset.^2) < 1 % if movement is less than 1 pixel, then quit looping.
                flag = 1;
            end
            j = j + 1;
        end
        display([i, j]);
        % this code copied from FV_moveROI.
        x = (max(UData(i).roi.xi) + min(UData(i).roi.xi))/2;
        y = (max(UData(i).roi.yi) + min(UData(i).roi.yi))/2;
        set(UData(i).ROIhandle,'XData',UData(i).roi.xi,'YData',UData(i).roi.yi,'UserData',UData(i));
        set(UData(i).texthandle, 'Position', [x,y],'UserData',UData(i));
        
        UserData2 = get(UData(i).mirrorROIhandle, 'UserData');
        UserData2.roi = UData(i).roi;
        set(UserData2.ROIhandle,'XData',UserData2.roi.xi,'YData',UserData2.roi.yi,'UserData',UserData2);
        set(UserData2.texthandle, 'Position', [x,y],'UserData',UserData2);
    end
end

FV_roiQuality(handles);



function FV_moveROI(h, offset)

% offset here is (x, y)

UserData = get(h,'UserData');
if iscell(UserData)
    UserData = cell2mat(UserData);
end

for i = 1:length(h)
    UserData(i).roi.xi = UserData(i).roi.xi + offset(1);
    UserData(i).roi.yi = UserData(i).roi.yi + offset(2);
    x = (max(UserData(i).roi.xi) + min(UserData(i).roi.xi))/2;
    y = (max(UserData(i).roi.yi) + min(UserData(i).roi.yi))/2;
    set(UserData(i).ROIhandle,'XData',UserData(i).roi.xi,'YData',UserData(i).roi.yi,'UserData',UserData(i));
    set(UserData(i).texthandle, 'Position', [x,y],'UserData',UserData(i));
    
    UserData2 = get(UserData(i).mirrorROIhandle, 'UserData');
    UserData2.roi = UserData(i).roi;
    set(UserData2.ROIhandle,'XData',UserData2.roi.xi,'YData',UserData2.roi.yi,'UserData',UserData2);
    set(UserData2.texthandle, 'Position', [x,y],'UserData',UserData2);

end

function FV_hotKeyControls(handles, keyData)

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

key = keyData.Key;
modifier = keyData.Modifier;

switch(key) 
    case {'rightarrow', 'leftarrow', 'uparrow', 'downarrow'}
        switch(key)
            case 'rightarrow'
                xStep = 1;
                yStep = 0;
            case 'leftarrow'
                xStep = -1;
                yStep = 0;
            case 'uparrow'
                xStep = 0;
                yStep = 1;
            case 'downarrow'
                xStep = 0;
                yStep = -1;
            otherwise
        end
        
        roiobj = findobj(handles.FLIMview,'Tag','FV_ROI', 'Selected', 'on');
        
        if ~isempty(roiobj)
            UserData = get(roiobj(1), 'UserData');
            UserData.roi.xi = UserData.roi.xi + xStep;
            UserData.roi.yi = UserData.roi.yi - yStep;
            set(roiobj,'XData',UserData.roi.xi,'YData',UserData.roi.yi,'UserData',UserData);
            x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
            y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
            set(UserData.texthandle, 'Position', [x,y],'UserData',UserData);
            
            % deal with the mirror ROI
            UData2 = get(UserData.mirrorROIhandle, 'UserData');
            UData2.roi = UserData.roi;
            set(UserData.mirrorROIhandle,'XData',UserData.roi.xi,'YData',UserData.roi.yi,'UserData',UData2);
            set(UserData.mirrorTexthandle, 'Position', [x, y],'UserData',UData2);
        end
end

% if length(modifier)==1 && strcmpi(modifier{1}, 'alt')
%     switch(key)
%       case 'k'
% %             global h_imstack3TabDirection;
% %             global jbm;
% %             global h_img3;
% %                 if strcmp(currentStructName,jbm.instancesOpen{end})
% %                     h_imstack3TabDirection = -1;
% %                 elseif strcmp(currentStructName,jbm.instancesOpen{1})
% %                     h_imstack3TabDirection = 1;
% %                 elseif ~exist('h_imstack3TabDirection')
% %                     h_imstack3TabDirection = 1
% %                 end
% %                     figureToMoveTo = h_img3.(jbm.instancesOpen{currentInd+h_imstack3TabDirection}).gh.currentHandles.h_imstack3;
% %                     figure(figureToMoveTo);
% 
% 
%             global jbm;
%             global h_img3;
% 
%             if ~isfield(jbm,'instancesOpen')
%                 disp('ERROR: CREATE DATASET');
%             else
%             for i = 1:length(jbm.instancesOpen)
%                 figure(h_img3.(jbm.instancesOpen{i}).gh.currentHandles.h_imstack3);
%             end
%             end
% 
%         case 'q'
%             h_adjZStackSlider3([0 0 -1], handles);
%         case 'w'
%             h_adjZStackSlider3([0 0 1], handles);
%         case 's'
%             h_adjZStackSlider3([1 0 0], handles);
%         case 'a'
%             h_adjZStackSlider3([-1 0 0], handles);
%         case 'z'
%             h_adjZStackSlider3([0 -1 0], handles);
%         case 'x'
%             h_adjZStackSlider3([0 1 0], handles);
%         case 'q'
%             h_adjZStackSlider3([0 0 -1], handles);
%         case 'w'
%             h_adjZStackSlider3([0 0 1], handles);
%         case 'd'
%             h_adjRedSlider([-1 0], handles);
%         case 'f'
%             h_adjRedSlider([1 0], handles);
%         case 'c'
%             h_adjRedSlider([0 -1], handles);
%         case 'v'
%             h_adjRedSlider([0 1], handles);
%         case 'g'
%             h_adjGreenSlider([-1 0], handles);
%         case 'h'
%             h_adjGreenSlider([1 0], handles);
%         case 'b'
%             h_adjGreenSlider([0 -1], handles);
%         case 'n'
%             h_adjGreenSlider([0 1], handles);
%         case 'o'
%             jbm_synapsescoringengine('new synapse',handles);
%         case 'e'
%             if currentStruct.state.fileTypeForSynAnalysis.value==2
%                 h_spineAssignment3(handles,'same');
%             end
% %        case 'k' % JBM111915 2D Distance
% %         global h_img3;
% %             [currentInd,handles,currentStruct,currentStructName] = h_getCurrendInd3(handles);
% %                 [x_coordinates_pixels,y_coordinates_pixels] = ginput(2);
% %                 current_img_info = jbm_quickInfo(h_img3.(currentStructName).info);
% %                 [x_FOV,y_FOV] = calculateFieldOfView(current_img_info.zoom);
% %                 x_coordinates_microns = x_coordinates_pixels*(x_FOV/current_img_info.binx);
% %                 y_coordinates_microns = y_coordinates_pixels*(y_FOV/current_img_info.biny);
% %                 pix_distance = pdist(horzcat(x_coordinates_microns,y_coordinates_microns));
% %                 assignin('base','LastCalc2D_Distance',pix_distance);
% %                 disp(['2D Distance (Micrometers): ' num2str(pix_distance)]);
%     
%         case 'r'
%             try
%                 currentValue = get(handles.setSynapseSpine,'value');
%                 newValue = xor(currentValue, 1);
%                 set(handles.setSynapseSpine,'value',newValue);
%             end
%             h_setROIProperties3(handles, 'spine');
%         case 'Ctrl-C'
%         case 'Ctrl-V'
%        
%                
%     end
% end
% 
% function h_adjZStackSlider3(steps, handles)
% % tic
% stepLow = steps(1);
% stepHigh = steps(2);
% stepPos = steps(3);
% [xlim,ylim,zlim] = h_getLimits3(handles);
% 
% if stepLow~=0
%     val = get(handles.zStackSlider1, 'value');
%     stepSize = get(handles.zStackSlider1,'SliderStep');
%     newValue = val + stepLow*stepSize(1);
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.zStackSlider1, 'value', newValue);
%     zstackLow = round(newValue*(diff(zlim))+1);
%     set(handles.zStackStrLow,'String',num2str(zstackLow));
%     h_zStackQuality3(handles);
%     h_replot3(handles);
% %   toc
% end
% 
% if stepHigh~=0
%     val = get(handles.zStackSlider2, 'value');
%     stepSize = get(handles.zStackSlider2,'SliderStep');
%     newValue = val + stepHigh*stepSize(1);
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.zStackSlider2, 'value', newValue);
%     zstackHigh = round(newValue*(diff(zlim))+1);
%     set(handles.zStackStrHigh,'String',num2str(zstackHigh));
%     h_zStackQuality3(handles);
%     h_replot3(handles);
% %   toc
% end
% 
% if stepPos~=0
%     val = get(handles.zPosSlider, 'value');
%     stepSize = get(handles.zPosSlider,'SliderStep');
%     newValue = val + stepPos*stepSize(1);
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.zPosSlider, 'value', newValue);
% %     toc
%     h_resetZPos3(handles);
% %     toc
% end
% 
% 
% 
% function h_adjRedSlider(steps, handles)
% 
% stepLow = steps(1);
% stepHigh = steps(2);
% 
% if stepLow~=0
%     val = get(handles.redLimitSlider1, 'value');
%     stepSize = get(handles.redLimitSlider1,'SliderStep');
%     newValue = val + stepLow*stepSize(1)*2;
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.redLimitSlider1, 'value', newValue);
%     maxIntensity = h_getMaxIntensity3(handles);
%     valueStr = round(newValue*maxIntensity);
%     
%     set(handles.redLimitStrLow,'String',num2str(valueStr));
%     h_cLimitQuality3(handles);
%     h_replot3(handles, 'fast');
% end
% 
% if stepHigh~=0
%     val = get(handles.redLimitSlider2, 'value');
%     stepSize = get(handles.redLimitSlider2,'SliderStep');
%     newValue = val + stepHigh*stepSize(1)*2;
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.redLimitSlider2, 'value', newValue);
%     maxIntensity = h_getMaxIntensity3(handles);
%     valueStr = round(newValue*maxIntensity);
%     
%     set(handles.redLimitStrHigh,'String',num2str(valueStr));
%     h_cLimitQuality3(handles);
%     h_replot3(handles, 'fast');
% end
%     
% function h_adjGreenSlider(steps, handles)
% 
% stepLow = steps(1);
% stepHigh = steps(2);
% 
% if stepLow~=0
%     val = get(handles.greenLimitSlider1, 'value');
%     stepSize = get(handles.greenLimitSlider1,'SliderStep');
%     newValue = val + stepLow*stepSize(1)*2;
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.greenLimitSlider1, 'value', newValue);
%     maxIntensity = h_getMaxIntensity3(handles);
%     valueStr = round(newValue*maxIntensity);
%     
%     set(handles.greenLimitStrLow,'String',num2str(valueStr));
%     h_cLimitQuality3(handles);
%     h_replot3(handles, 'fast');
% end
% 
% if stepHigh~=0
%     val = get(handles.greenLimitSlider2, 'value');
%     stepSize = get(handles.greenLimitSlider2,'SliderStep');
%     newValue = val + stepHigh*stepSize(1)*2;
%     if newValue<0
%         newValue = 0;
%     elseif newValue>1
%         newValue = 1;
%     end
%     set(handles.greenLimitSlider2, 'value', newValue);
%     maxIntensity = h_getMaxIntensity3(handles);
%     valueStr = round(newValue*maxIntensity);
%     
%     set(handles.greenLimitStrHigh,'String',num2str(valueStr));
%     h_cLimitQuality3(handles);
%     h_replot3(handles, 'fast');
% end
% 
% 

function FV_executeFitLifetime(handles)

global FV_img;

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;

% find the selected line
figObj = findobj('Tag','FVPlot', 'Type', 'figure', 'Selected', 'on');
if ~isempty(figObj)
    lineObj = findobj(figObj, 'Type', 'line', 'Tag', 'FV_lifetimeCurve', 'Selected', 'on');
    if isempty(lineObj)
        disp('Cannot find selected FV_lifetimeCurve.');
        return;
    end
else
    disp('Cannot find selected FVPlot.');
    return;
end

% get the data
intensity = get(lineObj,'YData');
t = get(lineObj,'XData');
% t_step = mean(diff(t));
% fit_range(1) = round(t(1)/t_step);
% fit_range(2) = round(t(end)/t_step);
% h_spc.temp.fit_range = fit_range;


switch state.lifetimeFittingOpt.value
    case 1 % fitting with single
        fittedData = FV_fitBySingleExp(t, intensity, handles); % will only use gaussian to simulate the prf. for using a real prf, checkout ss_fitBySingle
    case 2
        fittedData = FV_fitByDoubleExp(t, intensity, handles);
    otherwise
end

FV_updateBeta(handles, fittedData);
FV_drawFit(lineObj, fittedData.fittedTime, fittedData.fittedYdata, state.holdLifetimePlot.value);

FV_img.(currentStructName).lastAnalysis.lifetimeFit = fittedData;
assignin('base','lifetimeFit',fittedData);


% ss_drawfit (fitobj, t, fit);
% ss_dispbeta(handles,betahat);

function FV_updateBeta(handles, fittedData)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;

state.pop1Str.string = num2str(fittedData.pop1, 4);
state.tau1Str.string = num2str(fittedData.tau1);
state.pop2Str.string = num2str(fittedData.pop2, 4);
state.tau2Str.string = num2str(fittedData.tau2);
state.t0Str.string = num2str(fittedData.t0);
state.beta6Str.string = num2str(fittedData.beta6);
pop1Pct = fittedData.pop1 / (fittedData.pop1 + fittedData.pop2);
state.pop1PctStr.string = [num2str(pop1Pct*100,3),'%'];
state.pop2PctStr.string = [num2str((1-pop1Pct)*100,3),'%'];
state.avgTauStr.string = num2str(pop1Pct*fittedData.tau1 + (1-pop1Pct)*fittedData.tau2);

FV_img.(currentStructName).state = state; % update state as values are adjusted.

% note: fixOpts has been updated in the fitBySingleExp or fitByDoubleExp
% functions.
betaNames = FV_getBetaNames;
FV_setParaAccordingToState(handles, betaNames);



function betaNames = FV_getBetaNames

betaNames = {   'pop1Str';
                'tau1Str';
                'pop2Str';
                'tau2Str';
                't0Str';
                'beta6Str';
                'pop1PctStr';
                'pop2PctStr';
                'avgTauStr';
                'fixTau1Opt';
                'fixTau2Opt';
                'fixT0Opt';
                'fixBeta6Opt';
            };
        
        
function FV_drawFit(lineObj, t, y, holdOpt)

h = get(lineObj,'Parent');
axes(h);
UserData = get(lineObj,'UserData');
if isempty(UserData.fitCurveHandle)
    hold on;
    UserData.fitCurveHandle = plot(t,y,'r-');
    set(lineObj,'UserData',UserData);
%     set(UserData.fitCurveHandle,'Tag','FV_lifetimeCurveFit','UserData',UserData);
    hold off;
elseif holdOpt
    hold on;
    UserData.fitCurveHandle(end+1) = plot(t,y,'r-');
    set(lineObj,'UserData',UserData);
%     set(UserData.fitCurveHandle,'Tag','spc_lifetimeCurveFit','UserData',UserData);
    hold off;
else
    delete(UserData.fitCurveHandle); % if not holding, delete them as there may be multiple.
    hold on;
    UserData.fitCurveHandle = plot(t,y,'r-');
    set(lineObj,'UserData',UserData);
    %     set(UserData.fitCurveHandle,'Tag','FV_lifetimeCurveFit','UserData',UserData);
    hold off;
end

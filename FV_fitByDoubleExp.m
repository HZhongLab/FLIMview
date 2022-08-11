function fittedData = FV_fitByDoubleExp(t,intensity, handles)

global FV_img

[currentInd, handles, currentStruct, currentStructName] = FV_getCurrendInst(handles);

state = currentStruct.state;

t_step = mean(diff(t));
fit_range(1) = round(t(1)/t_step);
fit_range(2) = round(t(end)/t_step);
x = fit_range(1):fit_range(2); % fitting uses index rather than real time. Don't want to change now but keep in mind.

% try
	beta0(1)=str2double(state.pop1Str.string);
	beta0(2)=str2double(state.tau1Str.string);
	beta0(3)=str2double(state.pop2Str.string);
	beta0(4)=str2double(state.tau2Str.string);
	beta0(5)=str2double(state.t0Str.string);
	beta0(6)=str2double(state.beta6Str.string);
    beta0(2) = beta0(2)*1000/currentStruct.info.datainfo.psPerUnit;
	beta0(4) = beta0(4)*1000/currentStruct.info.datainfo.psPerUnit;
	beta0(5) = beta0(5)*1000/currentStruct.info.datainfo.psPerUnit;	
    beta0(6) = beta0(6)*1000/currentStruct.info.datainfo.psPerUnit;
% end

if beta0(1) <= 0
    beta0(1) = max(intensity);
end
if beta0(2) <= 0
    beta0(2) = sum(intensity.*(x-x(1)))/sum(intensity);
    state.fixTau1Opt.value = 0; % if it was not correctly set, then have to let it float
end

if beta0(3) <= 0
    beta0(3) = max(intensity)*0.7;
end
if beta0(4) <= 0
    beta0(4) = sum(intensity.*(x-x(1)))/sum(intensity)/currentStruct.info.datainfo.psPerUnit*1000;
    state.fixTau2Opt.value = 0; % if it was not correctly set, then have to let it float
end

if beta0(6) <= 0
% Karel's FLIM rig number
%     beta0(6) = 0.1567*1000/h_spc.spc.datainfo.psPerUnit;
%     set(handles.spc_beta6, 'String','0.1567');
%     beta0(6) = currentStruct.display.settings.PRFsigma*1000/h_spc.spc.datainfo.psPerUnit; % display no longer has PRFsigma
    beta0(6) = 0.148/currentStruct.info.datainfo.psPerUnit*1000;% this is slice rig setting ~2017
    state.beta6Str.string = num2str(beta0(6));
end
FV_img.(currentStructName).state = state; % update state as values are adjusted.

weight = sqrt(intensity)/sqrt(max(intensity));
% weight(lifetime < 1)=1; % this is copied from ss_firexp2gauss. Now think it is an error, should be below:
weight(intensity < 1) = 1; % not 0 or 0.1! see below.
% if intensity too low or abnormal, set it to very low weight. This should never happen though.
% But the old code infact is right: lower value is higher weight in ss_nlinfit. So 1 is the lowest weight.
% Using weight, Ryohei is trying to increase the fit at smaller intensities. 

global fittingState; % use fittingState to pass fix opts to the fit function. 
fittingState = state; % this is to avoid variable with identical names.
fittingState.pulseI = currentStruct.info.datainfo.pulseInt / currentStruct.info.datainfo.psPerUnit*1000;
fittingState.psPerUnit =  currentStruct.info.datainfo.psPerUnit;

[betahat,R,J,converge] = ss_nlinfit(x, intensity, weight, @FV_exp2Gauss, beta0);


fittedData.originalXdata = x;
fittedData.originalYdata = intensity;
fittedData.originalTime = t; % x is index, while t is the time.
fittedData.fixOpt.tau1 = fittingState.fixTau1Opt.value;
fittedData.fixOpt.tau2 = fittingState.fixTau2Opt.value;
fittedData.fixOpt.t0 = fittingState.fixT0Opt.value;
fittedData.fixOpt.beta6 = fittingState.fixBeta6Opt.value;

x2 = x(1):0.1:x(end);%10X oversample for fittedData
fittingState.fixTau1Opt.value = 0;%disable fixing here to perform evaluation using fitted betahat.
fittingState.fixTau2Opt.value = 0;
fittingState.fixt0Opt.value = 0;
fittingState.fixbeta6Opt.value = 0;

fittedData.fittedXdata = x2;
fittedData.fittedYdata = FV_exp2Gauss(betahat, x2);
fittedData.fittedTime = x2*fittingState.psPerUnit/1000; % x is index, while t is the time.
betahat([2, 4, 5, 6]) = betahat([2, 4, 5, 6])*fittingState.psPerUnit/1000;
fittedData.pop1 = betahat(1);
fittedData.tau1 = betahat(2);%*fittingState.psPerUnit/1000;
fittedData.pop2 = betahat(3);
fittedData.tau2 = betahat(4);%*fittingState.psPerUnit/1000;
fittedData.t0 = betahat(5);%*fittingState.psPerUnit/1000;
fittedData.beta6 = betahat(6);%*fittingState.psPerUnit/1000;
fittedData.beta = betahat;

fittedData.method = 'Double Exp';
fittedData.converge = converge;

clear global fittingState


function y = FV_exp2Gauss(beta0, x)
%beta0(1): peak
%beta0(2): exp tau
%beta0(5): center
%beta0(6): gaussian width
% 1/2*erfc[(s^2-tau*x)/{sqrt(2)*s*tau}] * exp[s^2/2/tau^2 - x/tau]

global fittingState

pulseI = fittingState.pulseI;

fixTau1 = fittingState.fixTau1Opt.value;
fixTau2 = fittingState.fixTau2Opt.value;
fixT0 = fittingState.fixT0Opt.value;
fixBeta6 = fittingState.fixBeta6Opt.value;

if (fixTau1)
    value = str2double(fittingState.tau1Str.string);
    tau1 = value*1000/fittingState.psPerUnit;
else
    tau1 = beta0(2);
end

if (fixTau2)
    value = str2double(fittingState.tau2Str.string);
    tau2 = value*1000/fittingState.psPerUnit;
else
    tau2 = beta0(4);
end

if fixT0
    value = str2double(fittingState.t0Str.string);
    deltapeak = value*1000/fittingState.psPerUnit;
else
    deltapeak=beta0(5);
end

if (fixBeta6)
    value = str2double(fittingState.beta6Str.string);
    tau_g = value * 1000/fittingState.psPerUnit;
else
    tau_g = beta0(6);
end

y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-deltapeak)/tau1);
y2 = erfc((tau_g^2-tau1*(x-deltapeak))/(sqrt(2)*tau1*tau_g));
y=y1.*y2;

%"Pre" pulse
y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-deltapeak+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-deltapeak+pulseI))/(sqrt(2)*tau1*tau_g));

ya = y1.*y2+y;
ya = ya/2;

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-deltapeak)/tau2);
y2 = erfc((tau_g^2-tau2*(x-deltapeak))/(sqrt(2)*tau2*tau_g));
y=y1.*y2;

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-deltapeak+pulseI)/tau2);
y2 = erfc((tau_g^2-tau2*(x-deltapeak+pulseI))/(sqrt(2)*tau2*tau_g));

yb = y1.*y2+y;
yb = yb/2;

y=ya+yb;

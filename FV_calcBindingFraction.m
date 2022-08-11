function bindingFraction = FV_calcBindingFraction(MPET, MPET0, beta0)

% Haining note: this is direct convert from ss_calcBindingFraction. No longer
% remember the rational/equation for corretion... May be a residue that in
% spc_stack, t0 was arbiturarily set...

tau1 = beta0(2);%*h_spc.spc.datainfo.psPerUnit/1000;
tau2 = beta0(4);%*h_spc.spc.datainfo.psPerUnit/1000;
pct1 = beta0(1)/(beta0(1)+beta0(3));
pct2 = 1 - pct1;
avgMPET = (pct1*tau1^2+pct2*tau2^2)/(pct1*tau1+pct2*tau2);

t0 = MPET0 - avgMPET;

corrMPET = MPET - t0;

bindingFraction = tau1*(tau1-corrMPET)/((tau1-tau2)*(tau1+tau2-corrMPET));
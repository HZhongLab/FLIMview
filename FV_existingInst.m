function [existingInstInd, nextInstInd, availableInd] = FV_existingInst

% this detects how many Instances is being used, and what is the next one
% available. Maximum number of instances 100.

global FV_img

if isstruct(FV_img)
    fieldNames = fieldnames(FV_img);
else
    fieldNames = {};
end

fieldNames(ismember(fieldNames,'common')) = [];

existingInstInd = [];
for i = 1:length(fieldNames)
    existingInstInd(i) = FV_img.(fieldNames{i}).instanceInd;
end

candidateInd = 1:100;
candidateInd(ismember(candidateInd, existingInstInd)) = [];
availableInd = candidateInd;
nextInstInd = candidateInd(1);


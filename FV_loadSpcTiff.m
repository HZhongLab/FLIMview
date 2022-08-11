function [spc, imageMod, intensity] = FV_loadSpcTiff (fname, frame_numbers)

% spc contains the meta data, equivalent to header or info. Note: spc
% contains the fitting and display settings from online display but it is
% no longer used. Just keep for now.

if ~(exist('frame_numbers')==1)
    frame_numbers = [];
end

finfo = imfinfo (fname);
header = finfo(1).ImageDescription;

if findstr(header, 'spc')
    evalc(header);
else
    disp('This is not a spc/FLIM file !!');
    return;
end

% if ~any(frame_numbers == 0)
    if isempty(frame_numbers)
        frame_numbers = [1:length(finfo)];
    else
        frame_numbers = frame_numbers(frame_numbers<=length(finfo) & frame_numbers>=1);
    end
    
    spc.filename = fname;
    
    for i = 1:length(frame_numbers)
        image1 = imread(fname, frame_numbers(i));
        imageMod(:,:,:,i) = reshape(image1,spc.size(1), spc.size(3), spc.size(2));
        if i == 1
            imageMod = repmat(imageMod, [1 1 1 length(frame_numbers)]);
        end
    end
    
    if max(imageMod(:)) <= 255 %try to reduce memory size.
        imageMod = uint8(imageMod);
    end
    
    intensity = uint16(squeeze(sum(imageMod, 1)));
    
%     try
%         spc.imageMod = repmat(uint8(zeros(spc.size(1),spc.size(3),spc.size(2))),[1,1,1,length(frame_numbers)]);
%         spc.project = zeros(spc.size(3),spc.size(2),length(frame_numbers));
%         for i = 1:length(frame_numbers)
%             image1 = uint8(imread(fname, frame_numbers(i)));
%             if max(image1(:)) == 255
%                 error;
%             end
%             project = sum(image1,1);
%             spc.imageMod(:,:,:,i) = reshape(image1,spc.size(1), spc.size(3), spc.size(2));
%             spc.project(:,:,i) = reshape(project, spc.size(3), spc.size(2));
%         end
%     catch
%         spc.imageMod = repmat(uint16(zeros(spc.size(1),spc.size(3),spc.size(2))),[1,1,1,length(frame_numbers)]);
%         spc.project = zeros(spc.size(3),spc.size(2),length(frame_numbers));
%         for i = 1:length(frame_numbers)
%             image1 = uint16(imread(fname, frame_numbers(i)));
%             project = sum(image1,1);
%             spc.imageMod(:,:,:,i) = reshape(image1,spc.size(1), spc.size(3), spc.size(2));
%             spc.project(:,:,i) = reshape(project, spc.size(3), spc.size(2));
%         end
%     end
%     
%     spc.lifetimeMap = h_calcSpcLifetimeMap(spc);
%     spc.lifetimeAll = sum(spc.imageMod(:,:),2);
%     thresh = spc.switches.lifetime_limit(1);
%     spc.lifetime = sum(spc.imageMod(:,find(spc.project>thresh)),2);
%     
%     if (exist('flag')==1)&strcmp(flag,'MemorySavingMode')
%         spc.imageMod = [];
%     end
% % end

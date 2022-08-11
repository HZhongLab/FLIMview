function [x, y, z] = h_calculateCenterOfMass(matrix)

% note: x is the second dimension, y is the first.

% the way below make the computer crash. (matrix too big)

% matrix = double(matrix);
% siz = size(matrix);
% if length(siz)<3
%     siz(3) = size(matrix,3);
% end
% [X, Y, Z] = meshgrid(1:siz(2), 1:siz(1), 1:siz(3));
% 
% matrixSum = sum(matrix(:));
% x = sum(sum(sum(matrix .* X, 1),2),3)/matrixSum;
% y = sum(sum(sum(matrix .* Y, 1),2),3)/matrixSum;
% z = sum(sum(sum(matrix .* Z, 1),2),3)/matrixSum;



% [x, y, z] = meshgrid(1:size(inputMatrix,2), 1:size(inputMatrix,1), 1:size(inputMatrix,3));
% 
% out.x = squeeze(sum(sum(sum(inputMatrix.*x,1),2),3))./squeeze(sum(sum(sum(inputMatrix,1),2),3));
% out.y = squeeze(sum(sum(sum(inputMatrix.*y,1),2),3))./squeeze(sum(sum(sum(inputMatrix,1),2),3));
% out.z = squeeze(sum(sum(sum(inputMatrix.*z,1),2),3))./squeeze(sum(sum(sum(inputMatrix,1),2),3));

X = squeeze(sum(sum(matrix, 1),3));
x = sum(X.*(1:length(X)))/sum(X);    

Y = squeeze(sum(sum(matrix, 2),3))';
y = sum(Y.*(1:length(Y)))/sum(Y); 

Z = squeeze(sum(sum(matrix, 1),2))';
z = sum(Z.*(1:length(Z)))/sum(Z); 
function imagePoints = get_Image_ChessboardGridCornerPoints(imageFileNames, MinCornerMetric, showDetection, x_grids, y_grids)
% Function: detect the chessboard grid corner points from images
% Input:
%     imageFileNames - the path of image with chessboard 
%     MinCornerMetric - the chessboard grid corner points detection parameter in image
%     showDetection - the flag of show the detection of chessboard grid corner points in image
%     x_grids - the number of chessboard width grids
%     y_grids - the number of chessboard lengrh grids
% Output:
%     imagePoints - the chessboard grid corner points of images
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% detect the chessboard grid corner points from images
[imagePointsLists, boardSize, imagesUsed] = ...
    detectCheckerboardPoints(imageFileNames, 'MinCornerMetric', MinCornerMetric);  
imageFileNames = imageFileNames(imagesUsed);
    
% get the coordinates of chessboard grid corner points from images
imagePoints = {};
for i = 1:size(imagePointsLists,3)
    imagePoints{i} = reorder_Image_ChessboardGridCornerPoints(imagePointsLists(:, :, i), x_grids, y_grids);
end

% show the chessboard grid corner points of images
if strcmp(showDetection, 'true')
    for i = 1:numel(imageFileNames)
        I = imread(imageFileNames{i});
        figure('NumberTitle', 'off', 'Name', ['detection ' imageFileNames{i}])
        image(I);
        hold on;
        plot(imagePoints{i}(1,1),imagePoints{i}(1,2),'go','MarkerSize', 8);       
        hold on;
        plot(imagePoints{i}(2:end,1),imagePoints{i}(2:end,2),'ro','MarkerSize', 8);
    end
end

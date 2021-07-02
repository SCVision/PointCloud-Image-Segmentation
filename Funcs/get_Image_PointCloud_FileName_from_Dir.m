function [imageFileNames, chessboardPointcloudFileNames] = get_Image_PointCloud_FileName_from_Dir(imageDir, igsFileDir, imageType)
% Function: get the file path of image and point cloud with chessboard from the file dir
% Input:
%     imageDir - the dir of images with chessboard
%     igsFileDir - the dir of igs file with chessboard
%     imageType - the type of image with chessboard
% Output:
%     imageFileNames - the path of images with chessboard
%     chessboardPointcloudFileNames - the path of point cloud file with chessboard
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

imageFileNames = {};
chessboardPointcloudFileNames = {};

dirOutput = dir(fullfile(imageDir,['*.' imageType]));
imageFileBaseNames = {dirOutput.name};
for i=1:numel(imageFileBaseNames)
    [pathstr,name,suffix] = fileparts(imageFileBaseNames{i});
    igsFileName = [igsFileDir '/' name '.igs'];
    if 2 == exist(igsFileName, 'file')
        imageFileNames{i} = [imageDir '/' imageFileBaseNames{i}];
        chessboardPointcloudFileNames{i} = igsFileName;
    end
end

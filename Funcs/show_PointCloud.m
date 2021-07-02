function show_PointCloud(idx, PointCloudFileName, PointCloudFileType)
% Function: show the point cloud
% Input:
%     idx - the index of point cloud files
%     PointCloudFileName - the file path of point cloud
%     PointCloudFileType - the file format of point cloud
% Output:
%     show the point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

figure
pointCloud = importdata([PointCloudFileName num2str(idx) '.' PointCloudFileType]);
pcshow(pointCloud);
title('final result')

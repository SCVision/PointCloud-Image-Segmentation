function show_reproject_PointCloud2Image(idx, imageFileNames, R, T, K, pointCloudPath)
% Function: project the chessboard point cloud to the corresponding image
% Input:
%     idx - the index of images with chessboard
%     imageFileNames -  the file path of images with chessboard
%     R - the joint rotation matrix
%     T - the joint translation vector
%     K - the camera intrinsic matrix
%     pointCloudPath - the file path of chessboard point cloud
% Output:
%     project the chessboard point cloud to the corresponding image
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

[pathstr,name,suffix]=fileparts(imageFileNames{idx});
pointCloudFilePath = [pointCloudPath '\' name '.txt'];

if 2 == exist(pointCloudFilePath, 'file')
    % show the image with chessboard
    I = imread(imageFileNames{idx});
    figure('NumberTitle', 'off', 'Name', ['PointCloudToImage ' imageFileNames{idx}])
    image(I);
    
    % get the chessboard point cloud
    pointCloud = [];
    pointCloudCell = importdata(pointCloudFilePath);
    for j = 1:size(pointCloudCell, 1)
        point = [pointCloudCell(j,1), pointCloudCell(j,2), pointCloudCell(j,3)];
        pointCloud = [pointCloud; point];
    end
    
    % project the chessboard point cloud to the corresponding image
    cameraPoints = R * (pointCloud' - T');
    perspectivePoints = K * cameraPoints;
    uvs = perspectivePoints ./ perspectivePoints(end,:);
    uv = uvs(1:end-1,:)';
    
    hold on;
    plot(uv(1:1,1),uv(1:2,2),'o','LineWidth',4,'MarkerSize',1,'Color','g');
    plot(uv(2:end,1),uv(2:end,2),'o','LineWidth',4,'MarkerSize',1,'Color','b');
end


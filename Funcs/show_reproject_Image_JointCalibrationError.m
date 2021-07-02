function show_reproject_Image_JointCalibrationError(idx, imagePoints, pointcloud, imageFileNames, R, T, K)
% Function: reproject the joint calibration error to image
% Input:
%     idx - the index of images with chessboard
%     imagePoints - the chessboard grid corner points of image
%     pointcloud - the chessboard grid corner points of point cloud
%     imageFileNames - the file path of images with chessboard
%     R - the joint rotation matrix
%     T - the joint translation vector
%     K - the camera intrinsic matrix
% Output:
%     reproject the joint calibration error to image
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% show the chessboard grid corner points of image in image
I = imread(imageFileNames{idx});
figure('NumberTitle', 'off', 'Name', ['reProjection ' imageFileNames{idx}])
image(I);
hold on;
plot(imagePoints{idx}(1,1),imagePoints{idx}(1,2),'go','MarkerSize', 8);
hold on;
plot(imagePoints{idx}(2:end,1),imagePoints{idx}(2:end,2),'ro','MarkerSize', 8);

% reproject the chessboard grid corner points of point cloud to corresponding image
cameraPoints = R * (pointcloud{idx}' - T');
perspectivePoints = K * cameraPoints;
uvs = perspectivePoints ./ perspectivePoints(end,:);
uv = uvs(1:end-1,:)';

hold on;
plot(uv(1,1),uv(1,2),'gx','MarkerSize', 8);
hold on;
plot(uv(2:end,1),uv(2:end,2),'bx','MarkerSize', 8);

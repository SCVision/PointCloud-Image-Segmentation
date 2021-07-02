path(path,'..\funcs')

%% 1. prepare raw data
curdir = pwd;

% point cloud file of chessboard
igsChessboardDir = [curdir '\' 'data\chessboard_pointcloud_igs']; % the edge of chessboard point cloud (.igs)
pointcloudChessboardDir = [curdir '\' 'data\chessboard_pointcloud']; % chessboard point cloud

% chessboard parameters
x_grids = 7; % the number of chessboard width grids
y_grids = 10; % the number of chessboard lengrh grids

% image file of chessboard
imageChessboardDir = 'data\chessboard_images';
imageType = 'jpg';
MinCornerMetric = 0.3; % grid corner points detection parameter in image

% camera parameters
focalLength    = [4.1940e+03, 4.1937e+03]; % camera focal length
principalPoint = [2.4652e+03, 1.6065e+03]; % camera principal point
global K;
K = [focalLength(1), 0,  principalPoint(1); 0, focalLength(2), principalPoint(2); 0, 0, 1]; % camera intrinsic matrix

% image size
imageSize = [3456, 5184];

% show the detection of chessboard grid corner points in image
onlyShowDetection = 'false';

% image file processing
[imageChessboardNames, chessboardPointcloudFileNames] = get_Image_PointCloud_FileName_from_Dir(imageChessboardDir, igsChessboardDir, imageType);

%% 2. get coordinates of chessboard grid corner points from the point cloud and image
ChessboardPointcloud = get_Pointcloud_ChessboardGridCornerPoints_from_Igs(chessboardPointcloudFileNames, x_grids, y_grids);
imagePoints = get_Image_ChessboardGridCornerPoints(imageChessboardNames, MinCornerMetric, onlyShowDetection, x_grids, y_grids);

%% 3. LiDAR and camera joint calibration
[R,T] = solve_PnP(imagePoints, ChessboardPointcloud, focalLength, principalPoint, K, imageSize); % get joint rotation matrix and joint translation vector

%% 4. show the results
idx = 1; % the index of chessboard point cloud
show_reproject_Image_JointCalibrationError(idx,imagePoints, ChessboardPointcloud, imageChessboardNames, R, T, K); % both of chessboard grid corner points of image and point cloud reproject to image
show_reproject_PointCloud2Image(idx,imageChessboardNames, R, T, K, pointcloudChessboardDir); % chessboard point cloud reproject to image
fprintf('K = %8.1f %8.1f %8.1f\n', K(1,1),K(1,2),K(1,3))
fprintf('    %8.1f %8.1f %8.1f\n', K(2,1),K(2,2),K(2,3))
fprintf('    %8.1f %8.1f %8.1f\n', K(3,1),K(3,2),K(3,3))
fprintf('R = %9.6f %9.6f %9.6f   T = %9.6f\n', R(1,1),R(1,2),R(1,3),T(1))
fprintf('    %9.6f %9.6f %9.6f       %9.6f\n', R(2,1),R(2,2),R(2,3),T(2))
fprintf('    %9.6f %9.6f %9.6f       %9.6f\n', R(3,1),R(3,2),R(3,3),T(3))

%% 5. save the results as the file(.txt)
save('data\result\CameraIntrinsicMatrix.txt','K','-ascii'); % save the camera intrinsic matrix
save('data\result\JointRotationMatrix.txt','R','-ascii'); % save the joint rotation matrix
save('data\result\JointTranslationMatrix.txt','T','-ascii'); % save the joint translation vector
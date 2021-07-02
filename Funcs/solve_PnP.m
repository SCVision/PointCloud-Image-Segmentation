function [R,T] = solve_PnP(imagePoints, worldPoints, focalLength, principalPoint, K, imageSize)
% Function: calculate the the joint rotation matrix and the joint translation vector by P3P algorithm
% Input:
%     imagePoints - the chessboard grid corner points of image
%     worldPoints - the chessboard grid corner points of point cloud
%     focalLength - the camera focal length
%     principalPoint - the camera principal point
%     K - the camera intrinsic matrix
%     imageSize - the size of images with chessboard
% Output:
%     R - the joint rotation matrix
%     T - the joint translation vector
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% get the chessboard grid corner points of image
jointImagePoints = [];
for i = 1:numel(imagePoints)
    jointImagePoints = [jointImagePoints; imagePoints{i}];
end

% get the chessboard grid corner points of point cloud
jointWorldPoints = [];
for i = 1:numel(worldPoints)
    jointWorldPoints = [jointWorldPoints; worldPoints{i}];
end

% calculate the joint rotation matrix and the joint translation vector by P3P algorithm
intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
% [R0, T0] = estimateWorldCameraPose(jointImagePoints, jointWorldPoints, ...
%     intrinsics, 'Confidence', 99.99, 'MaxReprojectionError', 6);
[R0, T0] = estimateWorldCameraPose(jointImagePoints, jointWorldPoints, ...
    intrinsics, 'Confidence', 99, 'MaxReprojectionError', 6);
x0 = [R0(1,:),R0(2,:),R0(3,:),T0];
xdata = jointWorldPoints;
ydata = [jointImagePoints; [0,0;0,0;0,0;1,1;1,1;1,1]];

% fit the joint rotation matrix and the joint translation vector by L-M algorithm
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
lb = [];
ub = [];    
options.MaxFunctionEvaluations = inf;
options.MaxIterations = inf;
options.FunctionTolerance = 1.0000e-16;
options.StepTolerance = 1.0000e-16;
options.Display = 'off';

[x,resnorm,residual,exitflag,output] = lsqcurvefit(@reproject_value,x0,xdata,ydata,lb, ub,options);
    
% get the joint rotation matrix and the joint translation vector
R = reshape(x(1:9),3,3)';
detR = det(R);
fprintf('detR = %8.4f\n', detR);
T = x(10:12);
function value = reproject_value(x, xdata)
% Function: construct the indice between pixels and joint rotation matrix
% Input:
%     x - the raw matrix with joint rotation matrix
%     xdata - the raw matrix with joint translation vector
% Output:
%     value - the indice between pixels and joint rotation matrix
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

global K;
R = reshape(x(1:9),3,3)';
T = x(10:12);
	
% convert the points of point cloud to pixels
cameraPoints = R * (xdata' - T');
perspectivePoints = K * cameraPoints;
uvs = perspectivePoints ./ perspectivePoints(end,:);
value = uvs(1:end-1,:)';

% construct the indice between pixels and joint rotation matrix
Rl = [dot(R(1,:),R(2,:)), dot(R(1,:), R(3,:)); ...
    dot(R(2,:),R(3,:)), dot(R(:,1), R(:,2)); ...
    dot(R(:,1),R(:,3)), dot(R(:,2), R(:,3)); ...
    norm(R(1,:)),  norm(R(2,:)); ...
    norm(R(3,:)),  norm(R(:,1)); ...
    norm(R(:,2)),  norm(R(:,3))];
           
value = [value; Rl];
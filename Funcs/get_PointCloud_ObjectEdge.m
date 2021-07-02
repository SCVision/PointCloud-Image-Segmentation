function get_PointCloud_ObjectEdge(idx, ImageObjectEdgeFileName, ImageObjectEdgeFileType, ...
    K, R, T, RawPointCloudFileName, RawPointCloudFileType, Euclidean_distance_threshold, ...
	RawPointCloudObjectEdgeFileName, RawPointCloudObjectEdgeFileType)
% Function: get the raw object edge from raw point cloud and object edge in image
% Input:
%     idx - the index of raw point cloud files
%     ImageObjectEdgeFileName - the file path of object edge in image
%     ImageObjectEdgeFileType - the file format of object edge in image
%     K - the camera intrinsic matrix
%     R - the joint rotation matrix
%     T - the joint translation vector
%     RawPointCloudFileName - the file path of raw point cloud
%     RawPointCloudFileType - the file format of raw point cloud
%     Euclidean_distance_threshold - the threshold of Euclidean distance between points
%     RawPointCloudObjectEdgeFileName - the file path of raw object edge in point cloud
%     RawPointCloudObjectEdgeFileType - the file format of raw object edge in point cloud
% Output:
%     the file of raw object edge in point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% import the file of object edge in image and raw point cloud
image_edge = importdata([ImageObjectEdgeFileName num2str(idx) '.' ImageObjectEdgeFileType]);
pointCloud_raw = importdata([RawPointCloudFileName num2str(idx) '.' RawPointCloudFileType]);
	
n=max(size(image_edge));
m=max(size(pointCloud_raw));
	
count=0; % the number of edge points
	
for i=1:m
    % convert the 3D points to pixels
    perspectivePoints = K * R * (pointCloud_raw(i,:)' - T');
    uvs = perspectivePoints ./ perspectivePoints(end,:);
    uv = uvs(1:end-1);
        
    % traverse the pixel coordinates of the target object in the image, and compare with the pixels converted from 3D points. 
    for j=1:n
		euclidean=sqrt((uv(1)-image_edge(j,1))^2+(uv(2)-image_edge(j,2))^2);% the Euclidean distance between the transformed pixel and the object edge pixel in the image
            
		% if the Euclidean distance is not greater than the threshold, it is determined as the 3D edge points of the object edge in point cloud
        if(euclidean<=Euclidean_distance_threshold)
            count=count+1;
            pointcloud_edge(count,:)=pointCloud_raw(i,:);
        end
    end
end
	
pointcloud_edge = unique(pointcloud_edge, "rows"); % remove duplicate points in object edge in point cloud
	
% show object edge in point cloud
figure; pcshow(pointCloud_raw);
title('raw data')
zlim([-1 2.5]); ylim([-3 0.5]); xlim([-0.5 3.5])	
figure; pcshow(pointcloud_edge);
title('point cloud edge')
zlim([-1 2.5]); ylim([-3 0.5]); xlim([-0.5 3.5])	
drawnow

save([RawPointCloudObjectEdgeFileName num2str(idx) '.' RawPointCloudObjectEdgeFileType],'pointcloud_edge','-ascii'); % save the file of object edge in point cloud
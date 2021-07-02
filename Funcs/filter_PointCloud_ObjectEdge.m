function filter_PointCloud_ObjectEdge(idx, RawPointCloudObjectEdgeFileName, RawPointCloudObjectEdgeFileType, ...
    points_Euclidean_distance_threshold, points_sum_threshold, FilterPointCloudObjectEdgeFileName, FilterPointCloudObjectEdgeFileType)
% Function: filter object edge in point cloud by statistical filter
% Input:
%     idx - the index of raw object edge files in point cloud
%     RawPointCloudObjectEdgeFileName - the file path of raw object edge in point cloud
%     RawPointCloudObjectEdgeFileType - the file format of raw object edge in point cloud
%     points_Euclidean_distance_threshold - the Euclidean distance threshold between 3D points
%     points_sum_threshold - the sum threshold of satisfactory 3D points
%     FilterPointCloudObjectEdgeFileName - the file path of filter object edge in point cloud
%     FilterPointCloudObjectEdgeFileType - the file format of filter object edge in point cloud
% Output:
%     the file of filter object edge in point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% import the file of raw object edge in point cloud
pointcloud_edge = importdata([RawPointCloudObjectEdgeFileName num2str(idx) '.' RawPointCloudObjectEdgeFileType]);
n = max(size(pointcloud_edge)); % the size of raw object edge in point cloud

sum = []; % the sum of satisfactory 3D points
pointcloud_edge_filter = []; % the filter object edge in point cloud
for i=1:n
    count=0;
    for j=1:n
        if(i~=j)
            euclidean=sqrt((pointcloud_edge(i,1)-pointcloud_edge(j,1))^2+...
			(pointcloud_edge(i,2)-pointcloud_edge(j,2))^2+(pointcloud_edge(i,3)-pointcloud_edge(j,3))^2);
			
			% if the Euclidean distance is not greater than the threshold, it is determined as the satisfactory 3D points
            if(euclidean<=points_Euclidean_distance_threshold)
                count=count+1;
            end
        end
    end
    sum=[sum;count];
end

% if the sum of satisfactory 3D points is greater than the threshold, it is determined as the filter object edge in point cloud
for i=1:n
    if(sum(i,1)>=points_sum_threshold)
        pointcloud_edge_filter=[pointcloud_edge_filter;pointcloud_edge(i,:)];
    end
end

% show the filter object edge in point cloud
figure
pcshow(pointcloud_edge_filter);
title('filtered point cloud edge')
drawnow

% save the file of filter object edge in point cloud
save([FilterPointCloudObjectEdgeFileName num2str(idx) '.' FilterPointCloudObjectEdgeFileType],'pointcloud_edge_filter','-ascii'); % save the file of object point cloud
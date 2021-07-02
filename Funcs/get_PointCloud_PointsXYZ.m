function [pos,pos_indice] = get_PointCloud_PointsXYZ(data, pointcloud, n)
% Function: construct the indice of same points between point cloud and the other point cloud
% Input:
%     data - the file of point cloud
%     pointcloud - the other file of point cloud
%     n - the number of file
% Output:
%     pos - the position of same points
%     pos_indice - the indice of same points
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

pos = zeros(n,3); % the position of same points
    
% traversing all points of point cloud
for i=1:n
    pos(i,:) = pointcloud;
        
    % extract the index of the point
    for j=1:size(data,1)
        if( data(j,:)==pos(i,:) )
            pos_indice(i)=j;% save the index of the selected point
        end
    end
end
% fprintf('\nthe index point£º%d\n',pos_indice) % save the indice of same points
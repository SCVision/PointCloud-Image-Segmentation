function get_PointCloud_Object_RegionGrowingSegmentation(idx, RawPointCloudFileName, ...
    RawPointCloudFileType, FilterPointCloudObjectEdgeFileName, FilterPointCloudObjectEdgeFileType, ...
    neighbor_points_threshold, angle_threshold, curvature_threshold, ...
    PointCloudObjectFileName, PointCloudObjectFileType)
% Function: get object point cloud by region growing segmentation based on object edge
% Input:
%     idx - the index of raw point cloud files
%     RawPointCloudFileName - the file path of raw point cloud
%     RawPointCloudFileType - the file format of raw point cloud
%     FilterPointCloudObjectEdgeFileName - the file path of filter object edge in point cloud
%     FilterPointCloudObjectEdgeFileType - the file format of filter object edge in point cloud
%     neighbor_points_threshold - the neighbor points threshold of seed points
%     angle_threshold - the angle threshold between normals of points
%     curvature_threshold - the curvature threshold of points
%     PointCloudObjectFileName - the file path of object point cloud
%     PointCloudObjectFileType - the file format of object point cloud
% Output:
%     the file of object point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% import point cloud file
pointcloud = importdata([RawPointCloudFileName num2str(idx) '.' RawPointCloudFileType]);
pointcloud_edge = importdata([FilterPointCloudObjectEdgeFileName num2str(idx) '.' FilterPointCloudObjectEdgeFileType]);
n = max(size(pointcloud_edge)); % the size of object edge in point cloud
m = max(size(pointcloud)); % the size of raw point cloud
max_edge = max(pointcloud_edge); % the large range of segmentation
min_edge = min(pointcloud_edge); % the small range of segmentation

pointcloud_raw=[]; % simplify the raw point cloud
for j = 1:m
	if(pointcloud(j,2)<=max_edge(2)&&pointcloud(j,2)>=min_edge(2)...
	&&pointcloud(j,3)<=max_edge(3)&&pointcloud(j,3)>=min_edge(3)...
	&&pointcloud(j,1)<=max_edge(1)&&pointcloud(j,1)>=min_edge(1))
		pointcloud_raw=[pointcloud_raw; pointcloud(j,:)];
	end
end
    
% construct octree and calculate normal vector and curvature by PCA
k=8;
[pn, pw] = get_PointCloud_Normals_Curvatures_PCA(pointcloud_raw(:,1:1:3)', k); % pn is normal vector, pw is curvature
pn=pn';
pw=pw';
    
% sort curvature from small to large
[pw_, indice_pw] = sort(pw); % pw_ is ordered curvature; indice_pw is index of corresponding point
    
% extract edge points from raw point cloud file and create index for the edge points
[pose,pose_indice] = get_PointCloud_PointsXYZ(pointcloud_raw(:,1:1:3),pointcloud_edge(1,:),1);
    
% traverse the edge points of point cloud
result=[]; % save segmentation results
fprintf('running:    %%');
for i=2:n
    fprintf('\b\b\b\b\b%3d%%\n',round(i*100/n));
    % when the edge points of the point cloud are different from the neighbor points, region growth segmentation begins
    if(pointcloud_edge(i,:)~=pointcloud_edge(i-1,:))
        % extract edge points from raw point cloud file and create index for the edge points
        [pose,pose_indice] = get_PointCloud_PointsXYZ(pointcloud_raw(:,1:1:3),pointcloud_edge(i,:),1);
            
        % according to the neighbor points threshold, the initial seed points are selected from the edge points, and region growth segmentation begins
        neighbors = transpose(knnsearch(pointcloud_raw(:,1:3), pointcloud_raw(:,1:3), 'k', neighbor_points_threshold+1));
        seeds=[]; % seed point set
        cluster=[]; % cluster point set
        pointcloud_raw(:,7)=0; % the flag of growth in points; 0 means point has not grown, 1 means point has grown
        current_neighbors8=[]; % the neighbor points of the seed point
            
        seeds(1,:)=[pose_indice pose]; % create index for the seed points
        cluster=seeds(1,2:end); % divide the seed point to cluster point set
        
        while(size(seeds)>0) % stop circulation when seed point set is empty
            current_seed=seeds(1,:); % set the seed point as the current seed point
            pointcloud_raw(seeds(1,1),7)=1; % mark the seed point as points which have grown
            seeds(1,:)=[]; % delete the seed point
                
            % according to the current seed point finds 8 neighbor points in neighbor point set
            current_neighbors8_indice=neighbors(2:end,current_seed(1,1));
                
            % check each neighbor point
            for seed_k=1:neighbor_points_threshold
                current_neighbor=pointcloud_raw(current_neighbors8_indice(seed_k),: );
                   
                % judge whether the current neighbor point has grown
				% if the current neighbor point has grown, replace it with the next one
				% if the current neighbor point has not grown, it will grow
                if current_neighbor(1,7)==1
                    continue;
                end

                % judge whether the angle meets the angle threshold
                current_neighbor_D_angle=compute_PointCloud_PointsAngle( pn(current_neighbors8_indice(seed_k),:),pn(current_seed(1,1),:) );
                % calculate the angle difference between the selected neighborhood point and the current seed point
					
				% if the angle is less than the threshold, the point can be divided to the cluster point set
                if(current_neighbor_D_angle<angle_threshold)
                    cluster=[cluster;current_neighbor(1,1:3)];
                    pointcloud_raw( current_neighbors8_indice(seed_k),7 )=1;
                        
                    % if the curvature is less than the threshold, the point can be set as a new seed point
                    if( abs(pw( pose_indice(1,1),1)-pw(current_neighbors8_indice(seed_k)  )  )<curvature_threshold)
                        seeds=[seeds;current_neighbors8_indice(seed_k) pointcloud_raw(current_neighbors8_indice(seed_k),1:3)];
                    end
                end
            end
        end
    	result=[result;cluster]; % save segmentation result
    end
end
	
result = unique(result, "rows"); % remove duplicate points in segmentation results
save([PointCloudObjectFileName num2str(idx) '.' PointCloudObjectFileType],'result','-ascii'); % save the file of object point cloud
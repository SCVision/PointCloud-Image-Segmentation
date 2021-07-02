path(path,'..\funcs')

% select raw point cloud
idx = 16; % 1~16

%% 1. prepare raw data
K = importdata('..\Calibr-main\data\result\CameraIntrinsicMatrix.txt'); % camera intrinsic matrix
R = importdata('..\Calibr-main\data\result\JointRotationMatrix.txt'); % joint rotation matrix
T = importdata('..\Calibr-main\data\result\JointTranslationMatrix.txt'); % joint translation matrix

% image file of object
ImageObjectFileName = 'data\Object_Image\';
ImageObjectFileType = 'jpg';

% raw point cloud file
RawPointCloudFileName = 'data\Raw_PointCloud\';
RawPointCloudFileType = 'txt';

% object edge in image
ImageObjectEdgeFileName = 'data\ObjectEdge_Image_results\ObjectEdge_Image_';
ImageObjectEdgeFileType = 'txt';

% raw object edge in point cloud
RawPointCloudObjectEdgeFileName = 'data\RawObjectEdge_PointCloud_results\RawObjectEdge_PointCloud_';
RawPointCloudObjectEdgeFileType = 'txt';

% filter object edge in point cloud
FilterPointCloudObjectEdgeFileName = 'data\FilterObjectEdge_PointCloud_results\FilterObjectEdge_PointCloud_';
FilterPointCloudObjectEdgeFileType = 'txt';

% object point cloud
PointCloudObjectFileName = 'data\Object_PointCloud_results\Object_PointCloud_';
PointCloudObjectFileType = 'txt';

%% 2. get the edge of object in image
get_Image_ObjectEdge(idx, ImageObjectFileName, ImageObjectFileType, ImageObjectEdgeFileName, ImageObjectEdgeFileType);

%% 3. get the edge of object in point cloud
pixels_Euclidean_distance_threshold = 50; % the Euclidean distance threshold between pixels

get_PointCloud_ObjectEdge(idx, ImageObjectEdgeFileName, ImageObjectEdgeFileType, ...
   K, R, T, RawPointCloudFileName, RawPointCloudFileType, pixels_Euclidean_distance_threshold, ...
   RawPointCloudObjectEdgeFileName, RawPointCloudObjectEdgeFileType);

%% 4. filter the edge of object in point cloud
points_Euclidean_distance_threshold = 0.2; % the Euclidean distance threshold between 3D points
points_sum_threshold = 200; % the sum threshold of satisfactory 3D points

filter_PointCloud_ObjectEdge(idx, RawPointCloudObjectEdgeFileName, RawPointCloudObjectEdgeFileType, ...
    points_Euclidean_distance_threshold, points_sum_threshold, FilterPointCloudObjectEdgeFileName,...
    FilterPointCloudObjectEdgeFileType);

%% 5. region growing segment based on object edge in point cloud
neighbor_points_threshold = 10; % the neighbor points threshold of seed points
angle_threshold = 15; % the angle threshold between normals of points
curvature_threshold = 1.0; % the curvature threshold of points

get_PointCloud_Object_RegionGrowingSegmentation(idx, RawPointCloudFileName, ...
    RawPointCloudFileType, FilterPointCloudObjectEdgeFileName, FilterPointCloudObjectEdgeFileType, ...
    neighbor_points_threshold, angle_threshold, curvature_threshold, ...
    PointCloudObjectFileName, PointCloudObjectFileType);
show_PointCloud(idx, PointCloudObjectFileName, PointCloudObjectFileType);

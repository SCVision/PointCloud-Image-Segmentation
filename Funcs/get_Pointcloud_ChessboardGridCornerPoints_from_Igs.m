function pointcloud = get_Pointcloud_ChessboardGridCornerPoints_from_Igs(fileNamesPath, x_grids, y_grids)
% Function: get the chessboard grid corner points from point cloud igs file
% Input:
%     fileNamesPath - the file path of igs file
%     x_grids - the number of chessboard width grids
%     y_grids - the number of chessboard lengrh grids
% Output:
%     pointcloud - the chessboard grid corner points of chessboard point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

four_pointcloud = {}; % the four vertices of chessboard point cloud
pointcloud = {}; % the chessboard grid corner points of chessboard point cloud
	
for i = 1:numel(fileNamesPath)
    [pathstr,name,suffix] = fileparts(fileNamesPath{i});
    txt_file_path = [pathstr '/' name '.txt'];
    copyfile(fileNamesPath{i},txt_file_path);
	cell_text = importdata(txt_file_path);

    % get the coordinates of four vertices of chessboard point cloud
    p1 = strsplit(cell_text{11},',');
    p2 = strsplit(cell_text{12},',');
    p3 = strsplit(cell_text{13},',');
    points1 = [str2num(p1{1}), str2num(p1{2}), str2num(p1{3})];
    points2 = [str2num(p1{4}), str2num(p2{1}), str2num(p2{2})];
    points3 = [str2num(p2{3}), str2num(p2{4}), str2num(p3{1})];
    points4 = [str2num(p3{2}), str2num(p3{3}), str2num(p3{4})];
    chessboard = [points1;points2;points3;points4];

    % sort the four vertices by z value from large to small
    [value, index] = sort(chessboard(:,end), 'descend');
    descend_points = [chessboard(index(1),:); chessboard(index(2),:); chessboard(index(3),:);chessboard(index(4),:)];
    four_pointcloud{i} = descend_points;
end

for i = 1:numel(four_pointcloud)
    p = four_pointcloud{i};

    origin = p(1,:); 
    vec_x = p(2,:) - p(1,:); % calculate the vector of x-coordinate
    vec_y = p(3,:) - p(1,:); % calculate the vector of y-coordinate

    % calculate the coordinates of the chessboard grid corner points of chessboard point cloud
	points_cloud_grids = [];
    for y = 1:(y_grids-1)
        for x = 1:(x_grids-1)
            new_points = origin + vec_x * (x/x_grids) + vec_y * (y/y_grids);
            points_cloud_grids = [points_cloud_grids; new_points];
        end
    end
        
	% get the coordinates of the chessboard grid corner points of chessboard point cloud
    pointcloud{i} = points_cloud_grids;
end
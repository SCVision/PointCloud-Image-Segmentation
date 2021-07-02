function imageCornerPoints = reorder_Image_ChessboardGridCornerPoints(input, x_grids, y_grids)
% Function: reorder the coordinates of the chessboard grid corner points in images
% Input:
%     input - the chessboard grid corner points in images
%     x_grids - the number of chessboard width grids
%     y_grids - the number of chessboard lengrh grids
% Output:
%     imageCornerPoints - the reordered coordinates of the chessboard grid corner points in images
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% sort the coordinates of the chessboard grid corner points by y value from small to large
[row, col] = size(input);
four_corner_row = [1, x_grids-1, row - (x_grids-1)+1, row];
four_corner_y = [input(four_corner_row(1),2); ...
    input(four_corner_row(2),2); input(four_corner_row(3),2); ...
    input(four_corner_row(4),2)];
[value, index] = sort(four_corner_y, 'ascend');
    
% reorder the coordinates of the chessboard grid corner points
point = [];
min_y_row = four_corner_row(index(1));
if min_y_row == four_corner_row(2)
    for i = 1:(y_grids-1)
        for j = 1:(x_grids-1)
            r = (i-1) * (x_grids-1) + (x_grids-1) - j + 1;
            point = [point; input(r,:)];
        end
    end
elseif  min_y_row == four_corner_row(3)
    for i = 1:(y_grids-1)
        r =  ((y_grids-1) - i) * (x_grids-1);
        point = [point; input(r+1:r+(x_grids-1),:)];
    end
elseif  min_y_row == four_corner_row(4)
    for i = 1:row
        point = [point; input(row-i+1,:)];
    end
else
    point = input;
end
	
% get the reordered coordinates of the chessboard grid corner points
imageCornerPoints = point;
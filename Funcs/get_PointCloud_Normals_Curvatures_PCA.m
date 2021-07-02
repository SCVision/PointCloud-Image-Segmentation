function [n,w] = get_PointCloud_Normals_Curvatures_PCA(p, k, neighbors)
% Function: compute the normal vector and curvature of point cloud by PCA algorithm
% Input:
%     p - the point cloud coordinates
%     k - the K-nearest neighbor parameter
%     neighbors -  transpose(knnsearch(transpose(p),transpose(p), 'k', k+1)) (it can be default)
% Output:
%     n - the normal vector of point cloud
%     w - the curvature of point cloud
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

if nargin < 2
    error('no bandwidth specified')
end
if nargin < 3
    neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1)); % the matrix of indexes
end
    
m = size(p,2); % get the dimension of the second dimension
n = zeros(3,m); % the matrix of normal vector
w = zeros(1,m); % the matrix of curvature
    
for i = 1:m
    x = p(:,neighbors(2:end, i));% the matrix of neighbor points
    p_bar=mean(x,2); % average each line
		
    % compute the eigenvalue and eigenvector of P by SVD algorithm
    P=(x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k))./(size(x,2)-1);
    [V,D] = eig(P); % D is the corresponding eigenvalue diagonal matrix, V is the eigenvector
    [d0, idx] = min(diag(D)); % d0 is minimum eigenvalue, idx is the number of columns index of the eigenvalue
    n(:,i) = V(:,idx); % the eigenvector corresponding to the minimum eigenvalue is the normal vector    
    
    % the direction of the normal vector
    flag = p(:,i) - p_bar; % the vector from the average point of the nearest neighbor to the corresponding point
    if dot(n(:,i),flag)<0 % if the product of this vector and the normal vector is negative (reverse)
        n(:,i)=-n(:,i); % the normal vector is reversed
    end
    if nargout > 1 
        w(1,i)=abs(d0)./sum(abs(diag(D))); % get the curvature of point cloud
    end
end
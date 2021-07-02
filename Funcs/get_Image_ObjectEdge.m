function get_Image_ObjectEdge(idx, ImageObjectFileName, ImageObjectFileType, ImageObjectEdgeFileName, ImageObjectEdgeFileType)
% Function: get the object edge from images
% Input:
%     idx - the index of image files
%     ImageObjectFileName - the file path of image with object
%     ImageObjectFileType - the file format of image with object
%     ImageObjectEdgeFileName - the file path of object edge in image
%     ImageObjectEdgeFileType - the file format of object edge in image
% Output:
%     the file of object edge in image
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

% import image file
img1 = imread([ImageObjectFileName num2str(idx) '.' ImageObjectFileType]);
img = rgb2gray(img1); % image graying
bw1 = im2bw(img,0.99); % image binaryzation
bw1 = ~imfill(~bw1,'holes');
bw2 = bwlabeln(~bw1); % connected component detection
NN = length(unique(bw2))-1; % the number of connected component
	
figure
background=imread('data\background.jpg');
image(background);
hold on
	
% get object edge from image
result=[];
for j=1:NN
	DD = bw2;
	DD(DD ~= j)=0;
	DD(DD == j)=1;
	DD = logical(DD);
	[X,Y] = find(DD == 1); 
			
	[B,L,N,A] = bwboundaries(DD);
	edge = B{1};
	edge2(:,1) = edge(:,2);
	edge2(:,2) = edge(:,1);
	result=[result;edge2];
		
	hold on
	plot(edge(:,2),edge(:,1),'r');
	clear edge2
end
hold off
title('image edge')
drawnow

% save object edge in image
filename = [ImageObjectEdgeFileName num2str(idx) '.' ImageObjectEdgeFileType];
save(filename,'result','-ascii');
function d_degree = compute_PointCloud_PointsAngle(a,b)
% Function: calculate the angle between two vectors
% Input:
%     a - vector a
%     b - vector b
% Output:
%     d_degree - the angle between vector a and vector b
%
% Writen by Shi, Tingyu (tyshi123@sina.cn), 20210608
%

c=dot(a,b); % calculate scalar product between vector a and vector b
    
% calculate the length of vector a
d=dot(a,a);
e=sqrt(d);
    
% calculate the length of vector b
f=dot(b,b);
g=sqrt(f);
	
% calculate the angle between vector a and vector b
h=c/(e*g);
z=acos(h);
d_degree=min(z/pi*180,180-z/pi*180);
clc, clearvars, close all
dest = imread('./target.png');
source = imread('./source.png');

figure(1)
imshow(source);
title('左上and右下定位一个rect（提取域）')
dot_source = int64(ginput(2)); % 左上and右下定位一个rect（提取域）

figure(2)
imshow(dest); 
title('左上一点(目标域)')
dot_dest = int64(ginput(1)); % 左上一点

%% axis and martix index change xy
assert(all(dot_source(2,:) > dot_source(1,:))...
    ,'err：选取范围规则：矩形区域两个点（第一个左上，第二个右下）');

%%
source_row = dot_source(1, 2):1:dot_source(2, 2); % martix row
source_col = dot_source(1, 1):1:dot_source(2, 1);
% source_copy = source(source_row, source_col, :);
m = length(source_row); % m x n
n = length(source_col);
result = double(dest);
for i = 1:3
    result(:, :, i) = pieFun( m, n, double(source(:,:,i))/255.,...
        double(dest(:,:,i))/255. , dot_dest, source_row, source_col);
end
result = uint8(result*255);
figure()
imshow(result);
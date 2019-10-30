clc, clearvars, close all
dest = imread('./target2.jpg');
source = imread('./source2.jpeg');

figure(1)
imshow(source);
title('左上and右下定位一个rect（提取域）')
dot_source = int64(ginput(2)); % 左上and右下定位一个rect（提取域）
assert(all(dot_source(2,:) > dot_source(1,:))...
    ,'err：选取范围规则：矩形区域两个点（第一个左上，第二个右下）');
assert(all(dot_source(2,:) < [size(source, 2), size(source, 1)]), '选取超出范围')
figure(2)
imshow(dest); 
title('左上一点(目标域)只能点在左上块')

source_row = dot_source(1, 2):1:dot_source(2, 2); % martix row
source_col = dot_source(1, 1):1:dot_source(2, 1);
% source_copy = source(source_row, source_col, :);
m = length(source_row); % m x n
n = length(source_col);

pointMax = [size(dest, 2)-n, size(dest, 1)-m];
line([pointMax(1), pointMax(1)], [0,size(dest, 1)], ...
    'color', 'r', 'lineWidth', 4);
line([0,size(dest, 2)], [pointMax(2), pointMax(2)], ...
    'color', 'r', 'lineWidth', 4);
dot_dest = int64(ginput(1)); % 左上一点

assert(all(dot_dest <= pointMax), '位置超出范围(必须点在左上块区域内)')
%%

result = double(dest);
for i = 1:3
    result(:, :, i) = pieFun( m, n, double(source(:,:,i))/255.,...
        double(dest(:,:,i))/255. , dot_dest, source_row, source_col);
end
result = uint8(result*255);
figure()
imshow(result);
title('最终融合结果')
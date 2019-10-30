function [ result ] = pieFun( m, n, source_copy, dest, dot_dest, source_row, source_col)
%PIE 此处显示有关此函数的摘要
%   此处显示详细说明
% m = length(source_row); % m x n
% n = length(source_col);
num = m*n; %变量个数
A = spalloc(num, num, 5*num);
% A = zeros(num, num);
for i = 1:num
    A(i, i) = 4;
    % 右
    if mod(i, n)
        A(i, i+1) = -1;
%     else
%         A(i, i) = 1;
%         continue
    end
    % 左
    if mod(i, n) ~= 1
        A(i, i-1) = -1;
%     else
%         A(i, i) = 1;
%         A(i, i+1) = 0;
%         continue
    end
    % 上
    if i > n
        A(i, i-n) = -1;
%     else
%         A(i, i) = 1;
%         A(i, i+1) = 0;
%         A(i, i-1) = 0;
%         continue
    end
    % 下
    if i+n <= num
        A(i, i+n) = -1;
%     else % 边
%         A(i, i) = 1;
%         A(i, i+1) = 0;
%         A(i, i-1) = 0;
%         A(i, i-n) = 0;
%         continue
    end

end
b = zeros(num, 1);
[id_jj, id_ii] = ind2sub([n, m], 1:num);
filter = [0 -1 0; -1 4 -1; 0 -1 0];
grad_source = imfilter(source_copy, filter);
grad_source = grad_source(source_row, source_col);
grad_dest = imfilter(dest, filter);
grad_dest = grad_dest(dot_dest(1, 2):dot_dest(1, 2)+m-1,...
    dot_dest(1, 1):dot_dest(1, 1)+n-1);
mask = abs(grad_source) < abs(grad_dest);
grad_source(mask) = grad_dest(mask);
for i = 1:num
    id_j = id_jj(i);
    id_i = id_ii(i);
    b(i) = b(i) + grad_source(id_i, id_j);
%     try
%     b(i) = 4*source_copy(id_i, id_j);
%     % 右
%     if id_j ~= n
%         b(i) = b(i) -source_copy(id_i, id_j+1);
%     else % 边
%         b(i) = b(i) +dest(dot_dest(1, 2)+id_i,  dot_dest(1, 1)+id_j+1);
%     end
%     % 左
%     if id_j ~= 1
%         b(i) = b(i) -source_copy(id_i, id_j-1);
%     else % 边
%         b(i) = b(i) +dest(dot_dest(1, 2)+id_i,  dot_dest(1, 1)+id_j-1);
%     end
%     % 上
%     if id_i ~= 1
%         b(i) = b(i) -source_copy(id_i-1, id_j);
%     else % 边
%         b(i) = b(i) +dest(dot_dest(1, 2)+id_i-1,  dot_dest(1, 1)+id_j);
%     end
%     % 下
%     if id_i ~= m
%         b(i) = b(i) -source_copy(id_i+1, id_j);
%     else % 边
%         b(i) = b(i) +dest(dot_dest(1, 2)+id_i+1,  dot_dest(1, 1)+id_j);
%     end
%     
%     catch
%         pause
%     end
    if id_j == n 
        b(i) = b(i) +dest(dot_dest(1, 2)+id_i-1,  dot_dest(1, 1)+id_j);
    end
    if id_j == 1
        b(i) = b(i) +dest(dot_dest(1, 2)+id_i-1,  dot_dest(1, 1)+id_j-2);
    end
    if id_i == 1 
        b(i) = b(i) +dest(dot_dest(1, 2)+id_i-2,  dot_dest(1, 1)+id_j-1);
    end
    if id_i == m
        b(i) = b(i) +dest(dot_dest(1, 2)+id_i,  dot_dest(1, 1)+id_j-1);
    end

%     if (id_j == n || id_j == 1 || id_i == 1 || id_i == m) % 边
% %         b(i) = dest(dot_dest(1, 2)+id_i,  dot_dest(1, 1)+id_j);
%         b(i) = b(i) + dest(dot_dest(1, 2)+id_i,  dot_dest(1, 1)+id_j);
%     end
end

x = A\b;
x = reshape(x, n, m);
result = dest;
result(dot_dest(1, 2):dot_dest(1, 2)+m-1, dot_dest(1, 1):dot_dest(1, 1)+n-1) = ...
    x.';

end


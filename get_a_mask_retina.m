function mask=get_a_mask_retina(image,mask_of_what)
% 假设 image 是要展示的图像
% image = imread('image.png');

% 显示图像
figure;
imageshow_auto_adjust(image)
title(sprintf('manual label %s', mask_of_what));


% 在图像上手工划定一个圆形区域
h = drawcircle('Color', 'r');

% 获取划定圆形的中心和半径
center = h.Center;
radius = h.Radius;

% 生成对应这一区域的掩码
[x, y] = meshgrid(1:size(image, 2), 1:size(image, 1));
mask = (x - center(1)).^2 + (y - center(2)).^2 <= radius^2;

% 显示生成的掩码
figure;
imshow(mask);
title('Generated Mask');

% 对掩码进行后续处理
% 例如，可以将掩码应用到图像上进行进一步处理
maskedImage = image .*uint16(mask);

% 显示处理后的图像
figure;
imageshow_auto_adjust(maskedImage);
title('Masked Image');

close all


function imageshow_auto_adjust(image_frame)
    currentImage = image_frame;
    
    % 去除像素值为0的点
    nonZeroPixels = currentImage(currentImage ~= 0);
    if isempty(nonZeroPixels)
        error('图像中所有像素值均为0，无法进行调整。');
    end
    minNonZero = min(nonZeroPixels(:));
    currentImage(currentImage == 0) = minNonZero;
    
    % 计算图像的平均值和方差
    meanValue = mean(nonZeroPixels(:));
    stdValue = std(double(nonZeroPixels(:)));
    
    % 使用平均值加减3倍方差重新映射图像
    low_in = max(0, meanValue - 3 * stdValue);
    high_in = min(255, meanValue + 3 * stdValue);
    
    % 确保 low_in 和 high_in 在有效范围内
    low_in = max(0, low_in);
    high_in = min(2^16, high_in);
    
    % 使用 imadjust 进行强度值映射
    adjustedImage = imadjust(currentImage, [low_in/2^16, high_in/2^16], [0, 1]);
    
    % 显示调整后的图像
    figure;
    imshow(adjustedImage);
    title('自动调整后的图像');
end

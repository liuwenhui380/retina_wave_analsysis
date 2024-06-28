function data_downsampling(filepath,downsample_path,downsample_factor)
% 设置输入和输出文件夹路径
inputFolder = filepath;
outputFolder = downsample_path;

% 确保输出文件夹存在，如果不存在则创建
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 获取输入文件夹中的所有 TIFF 文件
tiffFiles = dir(fullfile(inputFolder, '*.tif'));

% 初始化一个计数器，用于按时间序列命名输出文件
fileCounter = 1;

% 遍历所有 TIFF 文件
for i = 1:length(tiffFiles)
    % 读取 TIFF 文件
    tiffFileName = tiffFiles(i).name;
    tiffFilePath = fullfile(inputFolder, tiffFileName);
    tiffImage = imread(tiffFilePath);
    
    % 对图像进行降采样（例如，将图像缩小到一半）
    downsampledImage = imresize(tiffImage, downsample_factor);
    
    % 构建输出文件名
    outputFileName = sprintf('processed_image_%04d.tif', fileCounter);
    outputFilePath = fullfile(outputFolder, outputFileName);
    
    % 保存处理后的图像
    imwrite(downsampledImage, outputFilePath);
    
    % 更新计数器
    fileCounter = fileCounter + 1;
end

disp('所有 TIFF 图像已处理并保存完毕。');

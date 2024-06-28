function imageTimetable = data_readin_parfor(path, TimeStep, startIdx, endIdx)
    % 设置输入文件夹路径
    inputFolder = path;

    % 获取输入文件夹中的所有 TIFF 文件
    tiffFiles = dir(fullfile(inputFolder, '*.tif'));
    
    % 初始化时间表
    numImages = endIdx - startIdx + 1;
    imageStack = cell(numImages, 1); % 假设图像为16位
    Times = (0:TimeStep:(numImages-1)*TimeStep)' + (startIdx-1)*TimeStep;

    % 预先获取所有图像文件的信息
    tiffFilePaths = cell(numImages, 1);
    for i = 1:numImages
        tiffFilePaths{i} = fullfile(inputFolder, tiffFiles(startIdx + i - 1).name);
    end

    % 并行读取当前批次的 TIFF 文件
    parfor i = 1:numImages
        tiffImage = imread(tiffFilePaths{i});
        imageStack{i} = tiffImage;
    end

    % 创建时间表
    imageTimetable = timetable(Times, imageStack);
end

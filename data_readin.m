function imageTimetable = data_readin(path, TimeStep, startIdx, endIdx)
    % 设置输入文件夹路径
    inputFolder = path;

    % 获取输入文件夹中的所有 TIFF 文件
    tiffFiles = dir(fullfile(inputFolder, '*.tif'));
    
    % 初始化时间表
    numImages = endIdx - startIdx + 1;
    imageStack = cell(numImages, 1); % 假设图像为16位
    Times = (0:TimeStep:(numImages-1)*TimeStep)' + (startIdx-1)*TimeStep;

    % 顺序读取当前批次的 TIFF 文件
    for i = 1:numImages
        tiffFileName = tiffFiles(startIdx + i - 1).name;
        tiffFilePath = fullfile(inputFolder, tiffFileName);
        tiffImage = imread(tiffFilePath);
        imageStack{i} = tiffImage;
    end

    % 创建时间表
    imageTimetable = timetable(Times, imageStack);
end

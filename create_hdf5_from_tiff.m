function create_hdf5_from_tiff(inputFolder, outputFile)
    tiffFiles = dir(fullfile(inputFolder, '*.tif'));
    numImages = length(tiffFiles);
    
    % 获取第一张图像的大小
    sampleImage = imread(fullfile(inputFolder, tiffFiles(1).name));
    [rows, cols] = size(sampleImage);
    
    % 创建 HDF5 文件
    h5create(outputFile, '/images', [rows, cols, numImages], 'Datatype', 'uint16');
    
    for i = 1:numImages
        tiffFileName = tiffFiles(i).name;
        tiffFilePath = fullfile(inputFolder, tiffFileName);
        tiffImage = imread(tiffFilePath);
        h5write(outputFile, '/images', tiffImage, [1, 1, i], [rows, cols, 1]);
    end
end

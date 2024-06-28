function imageTimetable = data_readin_hdf5(hdf5File, TimeStep, startIdx, endIdx)
    % 获取 HDF5 文件中的图像数据
    info = h5info(hdf5File, '/images');
    numImages = endIdx - startIdx + 1;
    imageStack = cell(numImages, 1);
    Times = (0:TimeStep:(numImages-1)*TimeStep)' + (startIdx-1)*TimeStep;
    
    % 并行读取当前批次的图像数据
    parfor i = 1:numImages
        imageStack{i} = h5read(hdf5File, '/images', [1, 1, startIdx + i - 1], [info.Dataspace.Size(1), info.Dataspace.Size(2), 1]);
    end
    
    % 创建时间表
    imageTimetable = timetable(Times, imageStack);
end

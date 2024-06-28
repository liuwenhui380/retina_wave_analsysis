function imageTimetable = calculateDeltaF(imageTimetable, masked_name, timeWindow, threshold)
    % 获取时间表中的时间信息和masked data
    timeVector = imageTimetable.Times;
    maskedData = imageTimetable.(masked_name);
    
    % 预分配deltaF数组
    deltaF = cell(length(timeVector), 1);
    
    % 计算时间窗口的帧数
    windowSize = round(timeWindow / seconds(median(diff(timeVector))));
    
    % 获取每个cell中矩阵的大小
    sampleSize = size(maskedData{1}, 1);
    
    % 预分配一个3D数组来存储所有时间点的数据
    allData = zeros(sampleSize, length(timeVector));
    
    % 填充allData
    for i = 1:length(timeVector)
        allData(:, i) = maskedData{i};
    end
    
    % 使用movmean函数计算每个像素的移动平均
    windowAverage = movmean(allData, windowSize, 2, 'Endpoints', 'shrink');
    
    % 并行处理每一个时间点
    parfor i = 1:length(timeVector)
        tempDeltaF = double(maskedData{i}) - windowAverage(:, i);
        % 只保留大于threshold的元素，其余设为零
        deltaF{i} = tempDeltaF .* (tempDeltaF > windowAverage(:, i) * threshold);
    end
    
    % 将delta F添加到时间表中
    delta_str = strcat(extractBefore(masked_name, "_"), "_deltaF");
    imageTimetable.(delta_str) = deltaF;
end

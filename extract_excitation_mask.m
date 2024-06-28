function imageTimetable = extract_excitation_mask(imageTimetable, coordinate, deltaF_name)
    % 获取时间表中的时间信息和deltaF
    timeVector = imageTimetable.Times;
    deltaF = imageTimetable.(deltaF_name);
    
    % 获取图像大小
    imgSize = size(imageTimetable.imageStack{1});
    
    % 预计算线性索引
    linearIndices = sub2ind(imgSize, coordinate(:,1), coordinate(:,2));
    
    % 预分配excitation_mask数组
    excitation_mask = cell(length(timeVector), 1);
    
    % 并行处理每一行数据
    parfor i = 1:length(timeVector)
        deltaF_temp = deltaF{i};
        activeIndices = linearIndices(deltaF_temp > 0);
        
        % 使用稀疏矩阵来表示mask
        excitation_mask{i} = sparse(activeIndices, 1, true, prod(imgSize), 1, length(activeIndices));
    end
    
    % 将提取的数据存储在timetable中
    eye_sides = extractBefore(deltaF_name, "masked");
    properity_str = strcat(eye_sides, "_excitation_mask");
    imageTimetable.(properity_str) = excitation_mask;
end

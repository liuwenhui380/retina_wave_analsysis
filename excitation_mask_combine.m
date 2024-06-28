function [imageTimetable_fixed_mask] = excitation_mask_combine(imageTimetable, mask_name, close_size)
    % 获取时间表中的时间信息
    timeVector = imageTimetable.Times;

    % 获取deltaF
    logicalMask = imageTimetable.(mask_name);
    closedMask = cell(length(timeVector), 1);
    
    % 定义结构元素（例如，3x3的正方形）
    se = strel('square', close_size);

    % 并行处理每一行数据
    parfor i = 1:length(timeVector)
        % 将稀疏矩阵转换为全矩阵
        fullMask = full(logicalMask{i});
        
        % 1. 膨胀操作
        dilatedMask = imdilate(fullMask, se);
        
        closedMask_temp = imclose(dilatedMask, se);
        % 2. 收缩操作
        erodedMask = imerode(closedMask_temp, se);



        % 2. 收缩操作
        erodedMask = imerode(erodedMask, se);

        % 1. 膨胀操作
        finalMask = imdilate(erodedMask, se);

        % 将结果转换回稀疏矩阵
        closedMask{i} = sparse(finalMask);
    end

    imageTimetable_fixed_mask = imageTimetable;
    eye_sides = extractBefore(mask_name, "_excitation_mask");
    properity_str = strcat(eye_sides, "_closed_mask");
    % 将提取的数据存储在timetable的masked_data变量中
    imageTimetable_fixed_mask.(properity_str) = closedMask;
end

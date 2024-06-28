function imageTimetable = calculate_size_coordinate(imageTimetable, mask_name, nasal_vector, eye_proper)
    % 获取时间表中的时间信息
    timeVector = imageTimetable.Times;
    % 获取spilt_mask
    spilt_mask = imageTimetable.(mask_name);
    size_coordinate = cell(length(timeVector), 1);
    
    % 获取图像大小
    imgSize = size(imageTimetable.imageStack{1});
    
    % 预计算鼻侧单位向量
    nasal_unit_vector = (nasal_vector.end_point - nasal_vector.start_point) / ...
        norm(nasal_vector.end_point - nasal_vector.start_point);
    
    parfor i = 1:length(timeVector)
        temp_size_coordinate = struct('size', [], 'coordinate', []);
        temp_spilt_mask = spilt_mask{i};
        size_temp_array = zeros(length(temp_spilt_mask), 1);
        coordinate_temp_array = zeros(length(temp_spilt_mask), 2);
        
        for j = 1:length(temp_spilt_mask)
            % 将稀疏矩阵转换为全矩阵
            full_mask = full(reshape(temp_spilt_mask{j}, imgSize));
            
            % 计算大小
            size_temp = nnz(full_mask);
            
            % 使用 regionprops 计算重心
            stats = regionprops(full_mask, 'Centroid');
            
            % 获取重心坐标
            centroid = stats.Centroid;
            temp_vector = centroid - nasal_vector.start_point;
            
            % 计算水平和垂直距离
            horizontal_distance = dot(temp_vector, nasal_unit_vector);
            vertical_vector = temp_vector - horizontal_distance * nasal_unit_vector;
            vertical_distance = norm(vertical_vector);
            if eye_proper == "L"
                vertical_distance = -vertical_distance;
            end
            
            coordinate_temp = [horizontal_distance, vertical_distance];
            coordinate_temp_array(j, :) = coordinate_temp;
            size_temp_array(j) = size_temp;
        end
        
        temp_size_coordinate.size = size_temp_array;
        temp_size_coordinate.coordinate = coordinate_temp_array;
        size_coordinate{i} = temp_size_coordinate;
    end
    
    eye_sides = extractBefore(mask_name, "_closed");
    properity_str = strcat(eye_sides, "_size_coordinate");
    imageTimetable.(properity_str) = size_coordinate;
end

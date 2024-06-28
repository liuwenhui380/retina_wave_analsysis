function line_info=get_nasal_orientation(image,mask)
    % 例如，可以将掩码应用到图像上进行进一步处理
    maskedImage = image .*uint16(mask);
    % 显示图像
    figure;
    imageshow_auto_adjust(maskedImage); % 替换为你的图像文件名或图像数据
    title("please draw a line between optic disc and nasal side of retina");
    
    % 提示用户画线
    disp('watch out：The order of the endpoints matters when drawing ');
    
    % 获取用户输入的起点和终点
    [x, y] = ginput(2);
    
    % 绘制直线
    hold on;
    plot([x(1), x(2)], [y(1), y(2)], 'r-', 'LineWidth', 2);
    hold off;
    
    % 创建结构体存储起点和终点
    line_info = struct('start_point', [x(1), y(1)], 'end_point', [x(2), y(2)]);
    
    disp(line_info);
    pause(1)
    close all
end

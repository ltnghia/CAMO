function iou = CallIOU(sal_dir, gt_dir, count_bg)

files = dir([gt_dir '/*.png']);
if isempty(files)
    iou = NaN;
    return;
end

files = dir([sal_dir '/*.png']);
if isempty(files)
    iou = NaN;
    return;
end

result = [];
for i=1:length(files)
    try
        name = files(i).name;

        gt = imread([gt_dir '/' name(1:end-4) '.png']);
        gt = gt(:,:,1);
        gt(gt>0) = 1;
        gt = double(gt);
        
        sal = imread([sal_dir '/' name(1:end-4) '.png']);
        sal = sal(:,:,1);
        sal = (im2double(sal));
        
        threshold = std2(sal) + mean2(sal);
        
        %if(sum(gt(:)) == 0 && (sum(sum(sal >= threshold)) == 0 || sum(sal(:)) == 0))
        if(sum(sal(:)) == 0)    
        else
            sal(sal<threshold) = 0;
            sal(sal>=threshold) = 1;
        end
        
        if(sum(gt(:)) == 0)
            sal(1,1) = 1;
            gt(1,1) = 1;

            %if(count_bg)
                sal = 1-sal;
                gt = 1 - gt;
            %end
        end

        iou = IOU(sal, gt);
        result = [result; iou]; 
    catch
        disp(name);
    end
end

%iou = nanmean(result(:));
iou = result(:);

end

function [pre, rec] = CallPRC(sal_dir, gt_dir)

files = dir([gt_dir '/*.png']);
if isempty(files)
    pre = NaN;
    rec = NaN;
    return;
end

files = dir([sal_dir '/*.png']);
if isempty(files)
    pre = NaN;
    rec = NaN;
    return;
end

pre = [];
rec = [];

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

        [precision, recall] = PRC(sal, gt);

        pre = [pre; precision];
        rec = [rec; recall];
    catch
        disp(name);
    end
end

pre = nanmean(pre, 1);
rec = nanmean(rec, 1);

end

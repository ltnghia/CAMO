function mae = CallMAE(sal_dir, gt_dir)

files = dir([gt_dir '/*.png']);
if isempty(files)
    mae = NaN;
    return;
end

files = dir([sal_dir '/*.png']);
if isempty(files)
    mae = NaN;
    return;
end

mae = [];
for i=1:length(files)
    try
        name = files(i).name;

        sal = imread([sal_dir '/' name(1:end-4) '.png']);
        sal = sal(:,:,1);
        sal = (im2double(sal));

        gt = imread([gt_dir '/' name(1:end-4) '.png']);
        gt = gt(:,:,1);
        if(max(unique(gt)) <= 1)
            gt=double(gt);
        else
            gt = (im2double(gt));
        end

        mae = [mae; MAE(sal, gt)];
    catch
        disp(name);
    end
end

%mae = nanmean(mae);
mae = mae;
end

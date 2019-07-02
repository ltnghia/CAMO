function [pre, rec, f] = CallPRF(sal_dir, gt_dir, count_bg)

files = dir([gt_dir '/*.png']);
if isempty(files)
    pre = NaN;
    rec = NaN;
    f = NaN;
    return;
end

files = dir([sal_dir '/*.png']);
if isempty(files)
    pre = NaN;
    rec = NaN;
    f = NaN;
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

        [x, y, z] = PRF(sal, gt);
        result = [result; [x y z]]; 
    catch
        disp(name);
    end
end

% pre = nanmean(result(:,1));
% rec = nanmean(result(:,2));
% 
% beta_2 = 0.3;
% f = ((1 + beta_2) * (pre * rec)) / (beta_2 * pre + rec + eps);

pre = (result(:,1));
rec = (result(:,2));

beta_2 = 0.3;
f = ((1 + beta_2) * (pre .* rec)) ./ (beta_2 * pre + rec + eps);
end

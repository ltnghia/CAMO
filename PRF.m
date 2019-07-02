function [precision, recall, fbeta] = PRF(smapImg, gtImg)

if(size(smapImg,3) == 3)
	smapImg = rgb2gray(smapImg);
end

if ~islogical(gtImg)
    gtImg = gtImg(:,:,1) > mean2(gtImg(:,:,1));
end

if any(size(smapImg) ~= size(gtImg))
    smapImg = imresize(smapImg, [size(gtImg, 1) size(gtImg, 2)]);
end

threshold = mean2(smapImg);

tp = sum(smapImg(gtImg) >= threshold);
fp = sum(smapImg(~gtImg) >= threshold);
fn = sum(smapImg(gtImg) < threshold);

precision = tp / (tp + fp + eps);
recall = tp / (tp + fn + eps);

beta_2 = 0.3;
fbeta = ((1 + beta_2) * (precision .* recall)) ./ (beta_2 * precision + recall + eps);
end

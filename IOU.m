function iou = IOU(smapImg, gtImg)

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

iou = tp / (tp + fp + fn);

end

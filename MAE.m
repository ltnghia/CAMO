function mae = MAE(smapImg, gtImg)

if(size(smapImg,3) == 3)
	smapImg = rgb2gray(smapImg);
end

if ~islogical(gtImg)
    gtImg = gtImg(:,:,1) > mean2(gtImg(:,:,1));
end

%smapImg = mat2gray(smapImg);

if any(size(smapImg) ~= size(gtImg))
    smapImg = imresize(smapImg, [size(gtImg, 1) size(gtImg, 2)]);
end

err = abs(smapImg - gtImg);
mae = mean2(err);

end
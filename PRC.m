function [precision, recall] = PRC(smapImg, gtImg)

smapImg = smapImg(:,:,1);
if ~islogical(gtImg)
    gtImg = gtImg(:,:,1) > mean2(gtImg(:,:,1));
end

if any(size(smapImg) ~= size(gtImg))
    smapImg = imresize(smapImg, [size(gtImg, 1) size(gtImg, 2)]);
end

if (max(smapImg(:)) <= 1)
    smapImg = uint8(smapImg * 255);
end

%==========================================================================

precision = [];
recall = [];

%if(unique(smapImg) == 1)
%    smapImg(1,1) = 255;
%end

%disp(length(unique(smapImg)));

for i=0:255
    threshold = i;
    
    gtImg2 = gtImg;
    smapImg2 = smapImg;
    %if(length(unique(gtImg2)) == 1)
    %    gtImg2(1,1) = 1;
    %    smapImg0 = (smapImg2 >= threshold);
    %    if(length(unique(smapImg0)) == 1)
    %        smapImg2(1,1) = 255;
    %    end
    %end
    
    if(sum(smapImg2(:)) == 0)    
    else
        smapImg2(smapImg2<threshold) = 0;
        smapImg2(smapImg2>=threshold) = 1;
    end

    if(sum(gtImg2(:)) == 0)
        smapImg2(1,1) = 1;
        gtImg2(1,1) = 1;

        smapImg2 = 1-smapImg2;
        gtImg2 = 1 - gtImg2;
    end
    
    gtImg2 = gtImg2 > 0;

    smapImg2 = double(smapImg2);
    threshold = mean2(smapImg2);
    
    tp = sum(smapImg2(gtImg2) >= threshold);
    fp = sum(smapImg2(~gtImg2) >= threshold);
    fn = sum(smapImg2(gtImg2) < threshold);
    
    
    %if(sum(gtImg(:)) == 0 && (sum(sum(smapImg >= threshold)) == 0 || sum(smapImg(:)) == 0))
    %    precision(i+1) = 1;
    %    recall(i+1) = 1;
    %else
        precision(i+1) = tp / (tp + fp + eps);
        recall(i+1) = tp / (tp + fn + eps);
    %end
    %if(sum(gtImg(:)) == 0 && i==0)
    %    recall(i+1) = 1;
    %    precision(i+1) = 0;
    %end
   
end

end
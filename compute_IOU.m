clear;
clc;

gtpath = 'Camouflage_project/CAMO-COCO-V.1.0';
datasets = {'Camouflage'};

phases = {'Test'};

%==========================================================================

output_path = 'Results'; 
if(~exist(output_path, 'dir'))
    mkdir(output_path);
end


for k=1:length(phases)
    phase = phases{k};
    
    input_path = {};
    algs = {};

    input_path = [input_path; 'Camouflage_project/Results'];
    algs = [algs; ['ANet_' phase]];
    
    matrix_IOU = zeros(length(algs), length(datasets));
    matrix_IOU_cell = cell(length(algs), length(datasets));

    for i=1:length(datasets)
        dataset = datasets{i};
         for j=1:length(algs)
            alg = algs{j};
            fprintf('IOU: %s - %s\n', dataset, alg);

            gt_dir = [gtpath '/' dataset '/' phase '/GT/' ];
            %sal_dir = [input_path{j} '/' dataset '/' phase '/' ];
            sal_dir = [input_path{j}];

            iou = CallIOU(sal_dir, gt_dir, 0);

            iou_mean = nanmean(iou)

            matrix_IOU(j,i) = iou_mean;
            matrix_IOU_cell{j,i} = iou;
        end
    end

    save([output_path '/' 'matrix_IOU_' phase '.mat'], 'matrix_IOU', 'matrix_IOU_cell', 'algs', 'datasets');

end

%==========================================================================


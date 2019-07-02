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

    matrix_MAE = zeros(length(algs), length(datasets));
    matrix_MAE_cell = cell(length(algs), length(datasets));

    for i=1:length(datasets)
        dataset = datasets{i};
        for j=1:length(algs)
            alg = algs{j};

            fprintf('MAE: %s - %s\n', dataset, alg);

            gt_dir = [gtpath '/' dataset '/' phase '/GT/' ];
            %sal_dir = [input_path{j} '/' dataset '/' phase '/' ];
            sal_dir = [input_path{j}];

            mae = CallMAE(sal_dir, gt_dir);

            mae_mean = nanmean(mae)

            matrix_MAE(j,i) = mae_mean;
            matrix_MAE_cell{j,i} = mae;
        end
    end

    save([output_path '/' 'matrix_MAE_' phase '.mat'], 'matrix_MAE', 'matrix_MAE_cell', 'algs', 'datasets');

end

%==========================================================================


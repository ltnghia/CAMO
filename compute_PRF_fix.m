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

    matrix_F = zeros(length(algs), length(datasets));
    matrix_F_cell = cell(length(algs), length(datasets));

    for i=1:length(datasets)
        dataset = datasets{i};
        for j=1:length(algs)
            alg = algs{j};

            fprintf('F: %s - %s\n', dataset, alg);

            gt_dir = [gtpath '/' dataset '/' phase '/GT/' ];
            %sal_dir = [input_path{j} '/' dataset '/' phase '/' ];
            sal_dir = [input_path{j}];

            [pre, rec, f] = CallPRF_fix(sal_dir, gt_dir, 0); 

            pre_mean = nanmean(pre); rec_mean = nanmean(rec); f_adap_mean = 1.3 * pre_mean .* rec_mean ./ (0.3 * pre_mean + rec_mean + eps)

            matrix_F(j,i) = f_adap_mean;
            matrix_F_cell{j,i} = f;
        end
        
    end

    save([output_path '/' 'matrix_F_fix_' phase '.mat'], 'matrix_F', 'matrix_F_cell', 'algs', 'datasets');

end


%==========================================================================


function data_out(subjId)

% Spits out the results .txt file into a data_out folder( creates it if
% not there). Overwriting files is an issue, will be fixed soon, as well as
% adding detailed descriptions of what section does what.

subjId = upper(subjId);
[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'results' filesep()];
low_narrow_data = [];

for sessionNo = 1:2
    outputFile          = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) '_data.mat'];
    load(outputFile)
    new_data.roundness = design.roundness(1);
    new_data.widths = design.width;
    
    if sessionNo == 1
        for ii = 1:numel(data.block_type)
            if data.block_type{ii} == 'LN'
                if isempty(low_narrow_data)
                    low_narrow_data = data.mat{ii};
                    low_narrow_design = design.mat{ii};
                else
                    low_narrow_data = [low_narrow_data;data.mat{ii}];
                    low_narrow_design = [low_narrow_design; design.mat{ii}];
                end
            end
        end
    else
        for ii = 1:numel(data.mat)
            if data.block_type{ii} == 'LN'
                low_narrow_data = [low_narrow_data; data.mat{ii}];
                low_narrow_design = [low_narrow_design; design.mat{ii}];
            end
        end
    end
end

new_data.mat{1} = low_narrow_data;
new_data.design{1} = low_narrow_design;
new_data.block_type{1} = 'LN';
clearvars -except new_data subjId 

for iblock = 1:numel(new_data.block_type)
        
        % Calculates 'relative Cue' and puts it in the 4th column of data
        for trial = 1:numel(new_data.mat{iblock}(:,1))
            cueMean = new_data.mat{(iblock)}(trial,6);
            params.trial_mean = new_data.mat{(iblock)}(trial,3);
            vals = [cueMean-180-params.trial_mean cueMean-params.trial_mean cueMean+180-params.trial_mean];
            error = min(abs(vals));
            diff = vals(find(abs(vals)==error));
            new_data.mat{(iblock)}(trial,4) = diff;
        end
end
clearvars -except new_data subjId 

iblock = 1;
null_trials = [];
pre_trials = [];
prepost_trials = [];
post_trials = [];

for trial = 1:numel(new_data.mat{1}(:,1))
    if new_data.mat{iblock}(trial,7) == 0 %None
        null_trials = [null_trials; new_data.mat{iblock}(trial,:)];
        
    elseif new_data.mat{iblock}(trial,7) == 1 %Post
        post_trials = [post_trials; new_data.mat{iblock}(trial,:)];
        
    elseif new_data.mat{iblock}(trial,7) == 2 %Pre+Post
        prepost_trials = [prepost_trials; new_data.mat{iblock}(trial,:)];
        
    elseif new_data.mat{iblock}(trial,7) == 3 %Pre
        pre_trials = [pre_trials; new_data.mat{iblock}(trial,:)];
        
    end
end

Rcue_null = null_trials(:,4);
Rcue_post = post_trials(:,4);
Rcue_prepost = prepost_trials(:,4);
Rcue_pre = pre_trials(:,4);

Bias_null = null_trials(:,5);
Bias_post = post_trials(:,5);
Bias_prepost = prepost_trials(:,5);
Bias_pre = pre_trials(:,5);

null_fit = fit(Rcue_null,Bias_null,'poly1');
mean_null = mean(null_trials(:,5));
sd_null = std(null_trials(:,5));
rms_null = rms(null_trials(:,5));
MedAbs_null = median(abs(null_trials(:,5)));

post_fit = fit(Rcue_post,Bias_post,'poly1');
mean_post = mean(post_trials(:,5));
sd_post = std(post_trials(:,5));
rms_post = rms(post_trials(:,5));
MedAbs_post = median(abs(post_trials(:,5)));

prepost_fit = fit(Rcue_prepost,Bias_prepost,'poly1');
mean_prepost = mean(prepost_trials(:,5));
sd_prepost = std(prepost_trials(:,5));
rms_prepost = rms(prepost_trials(:,5));
MedAbs_prepost = median(abs(prepost_trials(:,5)));

pre_fit = fit(Rcue_pre, Bias_pre, 'poly1');
mean_pre = mean(pre_trials(:,5));
sd_pre = std(pre_trials(:,5));
rms_pre = rms(pre_trials(:,5));
MedAbs_pre = median(abs(pre_trials(:,5)));

new_data.mat_fields = {'trial','response','ellipse orientation','points','error','cue center','cue ID','resp_time'};

slope_null = null_fit(1) - null_fit(0);
slope_post = post_fit(1) - post_fit(0);
slope_prepost = prepost_fit(1) - prepost_fit(0);
slope_pre = pre_fit(1) - pre_fit(0);

rms_vals = [rms_null rms_post rms_prepost rms_pre];
medabs_vals = [MedAbs_null MedAbs_post MedAbs_prepost MedAbs_pre ];
slope_vals = [slope_null slope_post slope_prepost slope_pre];
mean_vals = [mean_null mean_post mean_prepost mean_pre];
sd_vals = [sd_null sd_post sd_prepost sd_pre];
titles{1} = 'null';titles{2} = 'post';titles{3} = 'prepost';titles{4} = 'pre';

[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'data_out' filesep()];
outputFile          = [resultsFolder,subjId,'data_out.txt']; 

% Create results folder if it does not exist already
if ~exist([currentPath filesep() 'data_out'],'dir')
    mkdir(currentPath,'data_out');
end

fileID = fopen(outputFile,'w');
formatfirst = 'Roundness: %4.4f \r\n';
formatwidth = 'Cue Width: %4.4f \r\n';
formatSpec = '\tRMS = %4.4f \r\n';
formatSpec2 = '\tMAD* = %4.4f \r\n';
formatSpec3 = '\r\nCue Condition: %s \r\n';
formatSpec4 = '\tMean = %4.4f \r\n';
formatSpec5 = '\tSlope = %4.4f \r\n';
formatSpec6 = '\tSD = %4.4f \r\n';
formatexpl  = '\r\n *Rescaled, multiplied by 1.48\r\n';
formatslope1 = '\r\ny-axis: bias 		= response_theta - target_theta\r\n';
formatslope2 = 'x-axis: relative cue 	= cue_mean - target_theta\r\n';
formatslope3 = 'slope = bias/relative cue\r\n';
formatslope4 = 'if response_theta = target_theta,\r\n';
formatslope5 = '\tslope = 0\r\n';
formatslope6 = 'if response_theta = cue_mean,\r\n';
formatslope7 = '\tslope = 1\r\n';

fprintf(fileID,formatfirst, new_data.roundness);
fprintf(fileID,formatwidth, new_data.widths(1));

for ii  = 1:4 
    fprintf(fileID,formatSpec3, titles{ii});
    fprintf(fileID,formatSpec5, slope_vals(ii));
    fprintf(fileID,formatSpec4, mean_vals(ii)); 
    fprintf(fileID,formatSpec6, sd_vals(ii));
    fprintf(fileID,formatSpec,  rms_vals(ii));
    fprintf(fileID,formatSpec2, 1.48*medabs_vals(ii));
end

fprintf(fileID,formatexpl);
fprintf(fileID,formatslope1);
fprintf(fileID,formatslope2);
fprintf(fileID,formatslope3);
fprintf(fileID,formatslope4);
fprintf(fileID,formatslope5);
fprintf(fileID,formatslope6);
fprintf(fileID,formatslope7);

fclose(fileID);
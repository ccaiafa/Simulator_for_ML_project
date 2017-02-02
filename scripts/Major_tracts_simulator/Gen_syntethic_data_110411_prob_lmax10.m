%% Script to compare old vs new results
clear
clc
%diary on

dataRootPathSTC = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Results/ETC_Dec2015/Single_TC/';
dataOutputPath = '/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/';
subject = '110411';

vista_soft_path = '/N/dc2/projects/lifebid/code/vistasoft/';
addpath(genpath(vista_soft_path));

mba_soft_path = '/N/dc2/projects/lifebid/code/mba';
addpath(genpath(mba_soft_path));

% Define path to the NEW LiFE
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

lparam = 'lmax10';
alg = 'PROB';
conn = 'connNUM01';

% load fe structure
fe_structureFile = deblank(ls(char(fullfile(dataRootPathSTC,'110411',strcat('fe_structure_*',subject,'_STC_','*run01','*',alg,'*',lparam,'*',conn,'.mat'))))); 
load(fe_structureFile);

%ind = find(~isnan(fe.life.fit.weights)&fe.life.fit.weights>0);

ind = find(fe.life.fit.weights>0);

TractsFile = deblank(ls(char(fullfile(dataRootPathSTC,strcat('fe_structure_*',subject,'*_STC_','*run01','*',alg,'*',lparam,'*',conn,'_TRACTS.mat')))));
load(TractsFile);
if length(ind)~=length(classification.index)
    disp('WARNING!: nnz weights number does not match with the numer of fibers in the tracts')
    keyboard
end

ind_fascicles = find(classification.index);
ind_fascicles = ind(ind_fascicles); % indices to major tract fascicles

new_weights = zeros(size(fe.life.fit.weights));
new_weights(ind_fascicles) = fe.life.fit.weights(ind_fascicles);

fe.life.fit.weights = new_weights; % keep weights 

predicted_signal = feGet(fe,'pSig fiber');
measured_signal = feGet(fe,'diffusion signal demeaned');

fe.life.predicted_signal_demean = predicted_signal;
fe.life.measured_signal_demean = measured_signal;

disp('SAVING RESULTS...')
save(fullfile(dataOutputPath,sprintf('fe_struct_with_predicted_sginal_%s_%s_%s_%s.mat',subject,num2str(alg),num2str(lparam),num2str(conn))), 'fe','-v7.3')


fit_on_predicted = feFitModel(fe.life.M, predicted_signal, 'bbnnls', 500, 'preconditioner');
save(fullfile(dataOutputPath,sprintf('fit_on_predicted_sginal_%s_%s_%s_%s.mat',subject,num2str(alg),num2str(lparam),num2str(conn))), 'fit_on_predicted','-v7.3')


% % Compute errors predicted - measured
% 
% predicted_signal = reshape(predicted_signal,size(fe.life.diffusion_signal_img));
% measured_signal = reshape(measured_signal,size(fe.life.diffusion_signal_img));
% 
% error = fe.life.diffusion_signal_img - predicted_signal;
% 
% rmse = sqrt(mean((measured_signal - predicted_signal).^2,2));


rmpath(genpath(new_LiFE_path));
rmpath(genpath(vista_soft_path));








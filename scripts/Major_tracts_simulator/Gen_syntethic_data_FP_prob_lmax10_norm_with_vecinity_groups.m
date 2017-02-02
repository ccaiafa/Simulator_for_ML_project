%% Script to compare old vs new results
clear
clc
%diary on

dataRootPathSTC = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Results/ETC_Dec2015/Single_TC/';
dataOutputPath = '/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/';
subject = 'FP';

%vista_soft_path = '/N/dc2/projects/lifebid/code/vistasoft/';
%addpath(genpath(vista_soft_path));

%mba_soft_path = '/N/dc2/projects/lifebid/code/mba';
%addpath(genpath(mba_soft_path));

% Define path to the NEW LiFE
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

lparam = 'lmax10';
alg = 'PROB';
conn = 'connNUM01';

%% load fe structure
fe_structureFile = deblank(ls(char(fullfile(dataRootPathSTC,'FP',strcat('fe_structure_*',subject,'_96dirs_b2000_1p5iso','*run01','*',alg,'*',lparam,'*',conn,'.mat'))))); 
load(fe_structureFile);

%% Normalization (divide lateral slices of Phi by S0(v))
vox = fe.life.M.Phi.subs(:,2);
vals = fe.life.M.Phi.vals;
S0 = feGet(fe,'s0_img');
vals = vals./S0(vox);
fe.life.M.Phi = sptensor(fe.life.M.Phi.subs,vals,size(fe.life.M.Phi));

%ind = find(~isnan(fe.life.fit.weights)&fe.life.fit.weights>0);

ind = find(fe.life.fit.weights>0);

TractsFile = deblank(ls(char(fullfile(dataRootPathSTC,strcat('fe_structure_*',subject,'*_STC_','*run01','*',alg,'*',lparam,'*',conn,'_TRACTS.mat')))));
load(TractsFile);
if length(ind)~=length(classification.index)
    disp('WARNING!: nnz weights number does not match with the numer of fibers in the tracts')
    keyboard
end

ind_fascicles = find(classification.index==19); % Arcuate
ind_fascicles = ind(ind_fascicles); % indices to major tract fascicles

%new_weights = zeros(size(fe.life.fit.weights));
new_weights = fe.life.fit.weights(ind_fascicles);

fe.life.fit.weights = new_weights; % keep weights 
fe.life.M.Phi = fe.life.M.Phi(:,:,ind_fascicles);

%% Gen predicted signal
predicted_signal = feGet(fe,'pSig fiber');
fe.life.predicted_signal_demean = predicted_signal;


%% Gen Measured signal
nBvecs  = feGet(fe,'nBvecs');
nVoxels = feGet(fe,'n voxels');

measured_signal = reshape(feGet(fe,'diffusion signal demeaned'), nBvecs, nVoxels);
measured_signal = measured_signal.*repmat(S0',nBvecs,1);
measured_signal = measured_signal(:);

%% Nearest-Neighbor vicinity groups for Atoms
fe.life.M.Atoms.orient = fe.life.M.orient;
fe.life.M = rmfield(fe.life.M,'orient');
fe.life.M.Atoms.vicinity = compute_NN_groups_dict(fe.life.M.Atoms.orient);

%% Nearest-Neighbor vicinity groups for voxels
fe.life.M.Voxels.coords = fe.roi.coords';
fe.life.M.Voxels.vicinity = compute_NN_groups_vox(fe.life.M.Voxels.coords);

disp('SAVING RESULTS...')
save(fullfile(dataOutputPath,sprintf('fe_struct_with_predicted_signal_from_Arcuate_norm%s_%s_%s_%s.mat',subject,num2str(alg),num2str(lparam),num2str(conn))), 'fe','-v7.3')


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








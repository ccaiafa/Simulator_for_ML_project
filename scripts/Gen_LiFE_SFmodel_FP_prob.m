%% Script to generate LiFE_SF model and results for STN96 FP dataset (probabilistic tractography)
clear
clc

dataRootPath = '/N/dc2/projects/lifebid/2t1/predator/';
dataOutputPath = '/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results';

subject = 'FP_96dirs_b2000_1p5iso';

vista_soft_path = '/N/dc2/projects/lifebid/code/vistasoft/';
addpath(genpath(vista_soft_path));

%% Define path to the LiFE_SF (Caiafa&Pestilli paper version)
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

feFileName    = 'life_build_model'; 

dwiFile       = deblank(ls(fullfile(dataRootPath,subject,'diffusion_data','run01*.nii.gz')));
dwiFileRepeat = deblank(ls(fullfile(dataRootPath,subject,'diffusion_data','run02*.nii.gz')));
t1File        = deblank(fullfile(dataRootPath,subject,'anatomy',  't1.nii.gz'));

% Probabilistic model
fgFileName    = deblank(ls(fullfile(dataRootPath,subject,'fibers', 'run01*lmax10*prob*.pdb')));

% Number of iterations for the optimization
Niter = 500;

%% Compute LiFE_SF model
L = 360;
tic
fe = feConnectomeInit(dwiFile,fgFileName,feFileName,[],dwiFileRepeat,t1File,L,[1,0],0);
disp(' ')
disp(['Time for LiFE_SF model construction with ','(L=',num2str(L),'=',num2str(toc)]);

save(fullfile(dataOutputPath,sprintf('fe_structure_%s%s.mat',subject,'_prob')), 'fe','-v7.3')
%% Fit the LiFE_SF model (Optimization)
tic
fe = feSet(fe,'fit',feFitModel(fe.life.M,feGet(fe,'dsigdemeaned'),'bbnnls',Niter,'preconditioner'));
disp(' ')
results.FittingTime = toc;
results.w = feGet(fe,'fiber weights');
results.subject = subject;
disp(['Time fitting =',num2str(results.FittingTime)]);
results.rmse = feGet(fe,'vox rmse');
results.rmsexv = feGetRep(fe,'vox rmse');
results.rrmse = feGetRep(fe,'vox rmse ratio');
results.L = L;

%% Save Results
disp('SAVING RESULTS...')
save(fullfile(dataOutputPath,sprintf('Results_%s_prob.mat',subject)), 'results','-v7.3')

rmpath(genpath(new_LiFE_path));
rmpath(genpath(vista_soft_path));








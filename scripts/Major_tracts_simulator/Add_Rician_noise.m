% Script that illustrate how to add Rician noise to a simulated diffusion
% signal
% Define path to the NEW LiFE
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

addpath('/N/dc2/projects/lifebid/code/ccaiafa/Simulator/Simulator_for_ML_project/scripts/Major_tracts_simulator/rician/');

% Define the parameter s of Rician noise 
s = 0;

% load fe_structure with simulated signal
load('/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/reduced_dict/fe_struct_with_predicted_signal_from_Arcuate_normFP_96dirs_b2000_1p5iso_PROB_lmax10_NUM01_L33.mat')

dSig0 = fe.life.diffusion_signal_img; % Extract diffusion image
noisy = ricernd(dSig0,s); % noisy signal 

% Replace original diffusion image with the noisy one
fe.life.diffusion_signal_img = noisy;

% Replace demeaned signal by the noise demeaned version
nVoxels = feGet(fe,'nVoxels');
nBvecs  = feGet(fe,'nBvecs');

% Compute the sNR amd store in fe structure
A_noise = sqrt(mean((noisy(:)-dSig0(:)).^2)); % Root mean squared (r.m.s) Noise
A_signal = sqrt(mean(dSig0(:).^2)); % Root mean squared (r.m.s) Signal
fe.life.SNR = 20*log(A_signal/A_noise);

% Here you can save the new fe_structure to disk
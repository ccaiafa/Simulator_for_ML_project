clear
clc

% Define path to the NEW LiFE
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

fe_structure_Path = '/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/fe_struct_with_predicted_signal_from_Arcuate_FP_PROB_lmax10_connNUM01.mat';
load(fe_structure_Path)

% Get indices of nodes
ind_nodes = find(fe.life.M.Phi);

figure
x = fe.roi.coords(ind_nodes(:,2),1)';
y = fe.roi.coords(ind_nodes(:,2),2)';
z = fe.roi.coords(ind_nodes(:,2),3)';
scatter3(x, y, z, 1);



rmpath(genpath(new_LiFE_path));
rmpath(genpath(vista_soft_path));


function [] = plot_fascicles


vista_soft_path = '/N/dc2/projects/lifebid/code/vistasoft/';
addpath(genpath(vista_soft_path));

mba_soft_path = '/N/dc2/projects/lifebid/code/mba';
addpath(genpath(mba_soft_path));

% Define path to the NEW LiFE
%new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/encode/';
addpath(genpath(new_LiFE_path));

%load('/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/reduced_dict/fe_struct_with_predicted_signal_from_Arcuate_normFP_96dirs_b2000_1p5iso_PROB_lmax10_NUM01_L33.mat')
load('/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/reduced_dict/fe_struct_with_predicted_signal_from_Arcuate_normFP_96dirs_b2000_1p5iso_PROB_lmax10_NUM01_L33.mat')


fascicle_set = [1,7]; % Fascicle(s) to plot, e.g. fascicle_set = 1:10

visualize_fasciles(fe,fascicle_set)

end

function [] = visualize_fasciles(fe,fascicle_set)
figure
hold on
axis equal
view([54.9 14]);

for n=fascicle_set
    sub = find(fe.life.M.Phi(:,:,n)); % Get atom and voxel indices for fiber n
    
    vox_coords = fe.roi.coords(sub(:,2)',:); % Get (x,y,z) coords of fascicles voxels
    %scatter3(vox_coords(:,1),vox_coords(:,2),vox_coords(:,3),2,'b'); %
    %this plot dots at voxels locations
    
    vox_orient = fe.life.M.Atoms.orient(:,sub(:,1))'; % Get orientations at every voxel
    
    fg_nodes = fe.fg.fibers{n}';
    plot3(fg_nodes(:,1)+1,fg_nodes(:,2)+1,fg_nodes(:,3)+1,'k','LineWidth',2); % plot fascicles nodes in red color
    
    quiver3(vox_coords(:,1),vox_coords(:,2),vox_coords(:,3),vox_orient(:,1),vox_orient(:,2),vox_orient(:,3),0.4,'b','LineWidth',1','MaxHeadSize',0.8) % put arrows at voxel locations with the orientation of atoms
    
end
end
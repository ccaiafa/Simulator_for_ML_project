% Define path to the NEW LiFE
new_LiFE_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/';
addpath(genpath(new_LiFE_path));

subject = 'FP';
lparam = 'lmax10';
alg = 'PROB';
conn = 'connNUM01';

dataOutputPath = '/N/dc2/projects/lifebid/code/ccaiafa/Simulator/results/Major_tracts_prediction/reduced_dict/';
fe_structureFile = deblank(ls(char(fullfile(dataOutputPath,'fe_struct_with_predicted_signal_from_Arcuate_normFP_96dirs_b2000_1p5iso_PROB_lmax10_NUM01_L33.mat')))); 
load(fe_structureFile);

%% plot atom and its neighbors
orient = fe.life.M.Atoms.orient;
vic = fe.life.M.Atoms.vicinity;

a = 100;
x= [0;orient(1,a)];
y= [0;orient(2,a)];
z= [0;orient(3,a)];

figure
plot3(x,y,z,'r');
hold on
plot3(-x,-y,-z,'r');

for n=2:size(vic,1)
    x= [0;orient(1,vic(n,a))];
    y= [0;orient(2,vic(n,a))];
    z= [0;orient(3,vic(n,a))];
    plot3(x,y,z,'b');
    plot3(-x,-y,-z,'b');
end

%% plot voxel and its neighbors
coord = fe.life.M.Voxels.coords;
vic = fe.life.M.Voxels.vicinity;

figure
hold on

%scatter(coord(1,:)',coord(2,:)',coord(3,:)','g')

v = 1500;
x= coord(1,v);
y= coord(2,v);
z= coord(3,v);


scatter3(x,y,z,'r');



for n=2:size(vic,1)
    x= coord(1,vic(n,v));
    y= coord(2,vic(n,v));
    z= coord(3,vic(n,v));
    scatter3(x,y,z,'b');
end


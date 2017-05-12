load('../data/omp_with_expert_fascicle/Phi_all_adjust_neighbor.mat')
load('../data/subsets/B.mat')
load('../data/subsets/compact_Y.mat')
load('../data/subsets/weights.mat');

ones_f = ones(size(w,1),1);
temp = ttm(Phi_sp,B,1);
Y_hat = ttv(temp,ones_f,3);

Y_exp = zeros(size(Y));
Y_hat_new = zeros(size(Y));
Y_real_real = zeros(size(Y));
temp = Y_hat.subs; %only consider non-zero elements in the sparse Y
val = Y_hat.vals;

for i = 1:size(temp,1)
    Y_exp(temp(i,1),temp(i,2)) = Y(temp(i,1),temp(i,2));
    Y_hat_new(temp(i,1),temp(i,2)) = val(i);
    Y_real_real(temp(i,1),temp(i,2)) = Y(temp(i,1),temp(i,2));%since we use expert Y as ``real'' Y
end

Y_exp(:,find(sum(abs(Y_exp),1)==0))=[];
Y_hat_new(:,find(sum(abs(Y_hat_new),1)==0))=[];
Y_real_real(:,find(sum(abs(Y_real_real),1)==0))=[];

r1 = (Y_exp-Y_real_real).*(Y_exp-Y_real_real);
r2 = (Y_hat_new-Y_real_real).*(Y_hat_new-Y_real_real);

res1 = sum(r1,1);
res2 = sum(r2,1);

sqrt(res1);
sqrt(res2);

histogram(res1,100,'DisplayStyle','stairs');

hold on

histogram(res2,100,'DisplayStyle','stairs');
xlabel('Model Error in constructing Y');
ylabel('P(Error)');
legend('Original RMSE (of expert Phi)','RMSE of new Phi');

hold off;





function [ NN_groups ] = compute_NN_groups_vox( coord )
Nv = size(coord,2);
Size_vicinity = 27;
NN_groups = zeros(Size_vicinity,Nv);
cte = sum(coord.^2,1)';
parfor v=1:Nv
   v
   d2 =  cte - 2*coord'*coord(:,v);
   [d2,i] = sort(d2,1,'ascend');
   NN_groups(:,v) = i(1:Size_vicinity);
end


end


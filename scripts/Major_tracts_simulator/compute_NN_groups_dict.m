function [ NN_groups ] = compute_NN_groups_dict( orient )
Na = size(orient,2);
Size_vicinity = 20;
NN_groups = zeros(Size_vicinity,Na);

parfor a=1:Na
   a
   proj = abs(orient'*orient(:,a));
   [proj,i] = sort(proj,1,'descend');
   NN_groups(:,a) = i(1:Size_vicinity);
end


end


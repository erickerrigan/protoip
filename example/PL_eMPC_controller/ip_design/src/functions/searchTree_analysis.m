function [min_depth, max_depth, nodes] = searchTree_analysis(ctrl)

% load expc_alpha.mat;
% ctrl=ctrl_alpha;
% ctrl=st_mpt_controller;
%region=1;

%extract search tree
tree=ctrl.details.searchTree;
[m, n]=size(tree);
nodes=m;

%compute min depth
a=find(tree(:,n-1)<0);
b=find(tree(:,n)<0);

if min(a)<min(b)
    min_node=min(a);
else
    min_node=min(b);
end

min_depth=1;

while min_node>1
    for i=1:min_node
        if ((tree(i,n-1)==min_node) || (tree(i,n)==min_node))
           min_node=i; 
           min_depth=min_depth+1;
           break; 
        end 
    end    
end


%compute max depth
if max(a)>max(b)
    max_node=max(a);
else
    max_node=max(b);
end

max_depth=1;

while max_node>1
    for i=1:max_node
        if ((tree(i,n-1)==max_node) || (tree(i,n)==max_node))
           max_node=i; 
           max_depth=max_depth+1;
           break; 
        end 
    end    
end 



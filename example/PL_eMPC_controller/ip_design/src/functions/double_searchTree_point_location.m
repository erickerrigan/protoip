function [region, depth, node_list] = double_searchTree_point_location(ctrl,x)

%extract search tree
tree=ctrl.details.searchTree;
[m, n]=size(tree);

node=1;
depth=0;

node_list=[];

while (1)
    
    node_list=[node_list node];
    
    depth=depth+1;
    
    a=tree(node,1:n-3)*x'-tree(node,n-2);
    
    if a<0
        %on plus-side of the hyperplane
        node=tree(node,n);
    else
        %on minus-side of the hyperplane
        node=tree(node,n-1);
    end
    
    if node<0
        break;
    end
    
end

region=-node;




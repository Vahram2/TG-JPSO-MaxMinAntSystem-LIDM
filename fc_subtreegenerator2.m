function [subtrees,subnodes]=fc_subtreegenerator2(node,tree,tank_id)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creation of node matrix: in node one can find links than connect any
% specifed node to tank
tree2=tree(1:2,:);
nnodes=size(node,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[r,c]=find(tree2==tank_id);
    r=1./(r./2);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if length(c)>1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Creating nodelinks matrix: nodelinks shows upstream links of each node
    for i=1:size(r)
        ans=tree2(r(i),c(i));
        nodelinks(1,(node(1,:)==ans))=c(i);
    end 
    tree2(:,c)=0;
    for j=2:nnodes;
        ind=find(nodelinks(j-1,:));
        for i=1:size(ind,2)
            [r,c]=find(tree2==node(1,ind(i)));r=1./(r./2);
            if sum(c)==0;continue;end
            for n=1:size(r);ans=tree2(r(n),c(n));nodelinks(j,...
                    (node(1,:)==ans))=c(n);end ;
            for n=1:size(r);ans=tree2(r(n),c(n));nodelinks(1:j-1,...
                    (node(1,:)==ans))=nodelinks(1:j-1,ind(i));end
            tree2(:,c)=0;
        end
        if sum(sum(tree2))==0;break;end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %creating subtrees and subnodes
    [r,link1]=find(tree(1:2,:)==tank_id);
    for j=1:length(link1);
        tree_nodes=sum(ismember(nodelinks,link1(j)));
        ans=node(1,tree_nodes==1);
        ans=sum(ismember(tree(1:2,:),ans))>0;
        subtrees{j}=tree(:,ans);        
        subnodes{j}=[node(:,tree_nodes==1),node(:,end)];
    end
else
    subtrees{1}=tree;
    subnodes{1}=node;
end
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


     
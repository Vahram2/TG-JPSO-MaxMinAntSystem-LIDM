%**************************************************************************
% fc_tank_tree_creator identifies thr down stream tree of each tank
%           
%input:
                % X : a particle, set of link ids
                % max_tree : 1st row contains all links id in max layout,
                %... 2nd & 3rd rows contain start & end nodes of each link,
                %... 4th row contains length of each link.
                % tank_id : identifies tanks of network
%output:     
                % tank_tree : a cell arrey, each cell contains list of
                %...links assosiated with specefic tank
%**************************************************************************
function [tank_tree]= fc_tank_tree_creator (X,max_tree,tank_id)
%**************************************************************************
tree_X = max_tree(:,(ismember(max_tree(1,:),X)));
tree2=tree_X(2:3,:);
for n = 1 : length(tank_id)
    [r,c]=find(tree2 == tank_id(n) );
    r=1./(r./2);
    tank_tree{n}=[];
    for i=1:size(r)
        nextnode(i)=tree2(r(i),c(i));
        ans = tree_X (1,c(i));
        tank_tree{n}=[tank_tree{n},ans];
        tree2 (:,c(i))=0;
    end
    if ~isempty(c)
        while ~isempty(nextnode)
            nextnode2 = [];
            for j = 1 : size(nextnode,2)
                [r,c] = find ( tree2 == nextnode(j) );
                r = 1./(r./2);
                for i = 1 : size(r)
                    nextnode2 = [ nextnode2 , tree2(r(i),c(i)) ];
                    ans = tree_X (1,c(i));
                    tank_tree{n} = [tank_tree{n},ans];
                    tree2(:,c(i)) = 0;
                end
            end
            nextnode = nextnode2;
        end
    end
end
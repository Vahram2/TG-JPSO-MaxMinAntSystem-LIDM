%MAIN LIDM CODE
%**************************************************************************
        %pso_tree: input solution(tree layout)from pso into LIDM for ObjFcn
        %...calculation
        %main_input: structure contains 2 entries,node & tree. node is an..
        %...array with 4 rows identifyes nodes of max layout:
                    %1st row: node id  
                    %2ed row: elevation
                    %3rd row: min required head
                    %4th row: haydrant discharge
        %...tree is an array identifyes links of present tree layout:
                    %1st row & 2ed row: ids of start and end nodes of links
                    %3rd row: link length(m)
                    %4th row: contains a number created as follows:                  
                    %...4th row=2ed row+10*1st row
        %input: structure contains  9filds:
                    %nnodes & nlinks: number of nodes & links  
                    %root_id & Z0: id and available elevation of tank node 
                    %vmin_max: contains max & min acceptable velocity
                    %c_heyzen: heyzen loss cofficent
                    %standard_d: 1st row contains available pipe sizes &
                    %...2end row contains their unit cost
                    %node & tree: their structure is same as in main_input,
                    %...but they both identifies a sub tree network which..
                    %...LIDM can analyze.
        %subtrees & subnodes: These are cell arrays contain tree an node of
        %...sub networks which LIDM can analyze.
        %I_L_X: a cell array(cells number eq subnetworks number).each cell
        %...contains a 3row matrix. 1st row is I(diameter id in standard_d)
        %...which is associated with L(pipe length specified in 2end row)
        %...3rd row is pipe length labeled with diameter one size biger...
        %...than I.
%**************************************************************************
function [cost,tree_size_optimized] = fc_main_LIDM2(subtrees,subnodes,input)
%**************************************************************************
    tree_size_optimized=[];
    for j=1:size(subtrees,2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Setting LIDM inputs:
        input.tree=subtrees{j};
        input.nlinks=size(subtrees{j},2);
        input.node=subnodes{j};
        input.nnodes=size(subnodes{j},2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %execution of function @LIDMnetwork that optimize pipe sizes in...
        %network specified in input structure and save size optimization...
        %results in...
        %I_L_X cell array.
        [I_L_X]=LIDMnetwork(input);
        tree_size_optimized=[tree_size_optimized,[input.tree(1:2,:);I_L_X]];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %Calculation size optimized network cost
    cost=input.standard_d(2,tree_size_optimized(3,:)).*...
        tree_size_optimized(4,:)+input.standard_d(2,...
        tree_size_optimized(3,:)+1).*tree_size_optimized(5,:);
    cost=sum(cost);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function endnode=fc_endnode2(endnode,stop)
n=0;tabu=[];nn=0;
for i=1:length(stop)
    ans=sum(stop==stop(i));
    ans=single(ans);
    if ans>nn;nn=ans;end
end
x=zeros((size(endnode,1)-2)*nn,length(stop),'single');clear nn
%%%%%%%%%%%%%%%%%%%%
for i=1:length(stop)
    if ~ismember(i,tabu)
        n=n+1;
        if stop(i)==0
            x(1:size(endnode,1),n)=endnode(:,i);
            x=single(x);
        else
            c=find(stop==stop(i));
            x(1,n)=stop(i);
            x(2,n)=0;
            for j=1:length(c)
                x(2,n)=endnode(2,c(j))+x(2,n);
                ind = find(x(:,n), 1, 'last');
                ans=length(endnode(3:end,c(j)));
                x(ind+1:ind+ans,n)=endnode(3:end,c(j));
                x=single(x);
            end
            tabu=[tabu,c];
        end
    end   
end
ans=sum(x(1,:)~=0);
x=x(:,1:ans);
%%
n=0;tabu=[];nn=0;
for i=1:size(x,2)
    ans=sum(x(1,:)==x(1,i));
    ans=single(ans);
    if ans>nn;nn=ans;end
end
y=zeros(single(size(x,1)-2)*nn,length(x(1,:)),'single');clear nn
%%%%%%%%%%%%%%%%
for i=1:size(x,2)
    if ~ismember(i,tabu)
        n=n+1;
            c=find(x(1,:)==x(1,i));
            y(1,n)=x(1,i);
            y(2,n)=0;
            for j=1:length(c)
                y(2,n)=x(2,c(j))+y(2,n);
                ind = find(y(:,n), 1, 'last');
                ans=length(x(3:end,c(j)));
                y(ind+1:ind+ans,n)=single(x(3:end,c(j)));
            end
            tabu=[tabu,c];
        
    end   
end
clear n ind c i j tabu
ans=sum(y(1,:)~=0);
endnode=y(:,1:ans);

    
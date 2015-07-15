function neighbours = generateNeighbours(scheduled_tp, buckets)
    neighbours = zeros(8, 3, 50);
    validList = zeros(8,1);
    for n = 1:50
        valid = false;
        while (~valid)
            for j = 1:8
                neighbours(j,:,n) = [ ...
                    scheduled_tp(j,1) ...
                    scheduled_tp(j,2) ...
                    buckets(randi(size(buckets,1)),1)];
                if(buckets(find(neighbours(j,3,n) == 1342),2) - neighbours(j,3,n) > neighbours(j,2,n))
                    validList(j) = 1;
                end 
            end
            for k=1:8
                if (size(find(neighbours(k,3,n)==neighbours(:,3,n)),1) == 1)
                    validList(k)=1;
                else
                    validList(k)=0;
                end
            end
            
            if (sum(find(validList==0)) == 0)
                valid = true;
            else
                valid = false;
            end
        end
    end
end
L = [];
test_size=100:100;
for SIZE=test_size
    X = SIZE;
    Y = SIZE;
    Z = 3;
    
    for l=1:(X+Y+Z-2)
        %L(SIZE,l) = 0;
        L(l,SIZE) = 0;
    end

    for a=1:X
        for b=1:Y
            %for c=1:Z
            c=1; %matrix A
            source = [a,b,1];
            destination = [b,a,3];
            comm_len= abs(source(1) - destination(1)) +abs(source(2) - destination(2))+abs(source(3) - destination(3))+1;
            L(comm_len,SIZE) = L(comm_len,SIZE)+1;
            c=2; %matrix B
            source = [a,b,3];
            for k=1:SIZE
            destination = [k,a,2];
            comm_len= abs(source(1) - destination(1)) +abs(source(2) - destination(2))+abs(source(3) - destination(3))+1;
            L(comm_len,SIZE) = L(comm_len,SIZE)+1;
            end
            
        end
    end
end

for SIZE=test_size
    subplot(1,1,SIZE-test_size(1)+1);
    bar(L(:,SIZE));
    legend(char('Z=3, X=Y=',num2str(SIZE)));
    xlabel('Length (hopes)'); ylabel('No. of communication'); title('Distribution of communication length of Matrix benchmarks');

end



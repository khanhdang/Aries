L = [];
test_size=4:6;
for SIZE=test_size
    X = SIZE;
    Y = SIZE;
    Z = SIZE;
    
    for l=1:(X+Y+Z-2)
        %L(SIZE,l) = 0;
        L(l,SIZE) = 0;
    end

    for a=1:X
        for b=1:Y
            for c=1:Z
                source = [a,b,c];
                for m=1:X
                    for n=1:Y
                        for p=1:Z
                            destination = [m,n,p];
                            comm_len= abs(source(1) - destination(1)) +abs(source(2) - destination(2))+abs(source(3) - destination(3))+1;
                            L(comm_len,SIZE) = L(comm_len,SIZE)+1;
                        end
                    end
                end
                %L(SIZE,comm_len) = L(SIZE,comm_len)+1;
                
            end
        end
    end
end

for SIZE=test_size
    subplot(3,1,SIZE-test_size(1)+1);
    bar(L(:,SIZE));
    legend(char('X=Y=Z=',num2str(SIZE)));
    xlabel('Length (hopes)'); ylabel('No. of communication'); title('Distribution of communication length of Uniform benchmarks');

end



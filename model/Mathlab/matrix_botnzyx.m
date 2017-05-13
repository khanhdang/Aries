%L = [];
clear all;
clc;
xlink = []; %(X-1)*Y*Z
rxlink = [];
ylink = []; %X*(Y-1)*Z
rylink = [];
zlink = []; %X*Y*(Z-1)r
rzlink = [];
for SIZE=10:10
    X = SIZE;
    Y = SIZE;
    Z = 3;
    %for l=1:(X+Y+Z-2)
        %L(l,SIZE) = 0;
        xlink(1:X,1:Y,1:Z,SIZE)=0;
        ylink(1:X,1:Y,1:Z,SIZE)=0;
        zlink(1:X,1:Y,1:Z,SIZE)=0;
        rxlink(1:X,1:Y,1:Z,SIZE)=0;
        rylink(1:X,1:Y,1:Z,SIZE)=0;
        rzlink(1:X,1:Y,1:Z,SIZE)=0;
    %end

    for a=1:X
        for b=1:Y
            %for c=1:Z
            c=1; %matrix A
            current = [a,b,1];
            destination = [b,a,3];
            
            while (current(1) ~= destination(1) || current(2) ~= destination(2) || current(3) ~= destination(3))         
                if (current(3) < destination (3))
                    zlink(current(1),current(2),current(3),SIZE)=zlink(current(1),current(2),current(3),SIZE)+1;
                    current(3) = current(3)+1;
                elseif (current(3) > destination (3))
                    rzlink(current(1),current(2),current(3)-1,SIZE)=rzlink(current(1),current(2),current(3)-1,SIZE)+1;
                    current(3) = current(3)-1;
                else % equal
                    %disp(current(1));
                    if (current(2) < destination (2))
                        ylink(current(1),current(2),current(3),SIZE)=ylink(current(1),current(2),current(3),SIZE)+1;
                        current(2) = current(2)+1;
                        %disp(current(2));
                    elseif (current(2) > destination (2))
                        rylink(current(1),current(2),current(3),SIZE)=rylink(current(1),current(2),current(3),SIZE)+1;
                        current(2) = current(2)-1;
                        %disp(current(2));
                    else % equal
                        if (current(1) < destination (1))
                            xlink(current(1),current(2),current(3),SIZE)=xlink(current(1),current(2),current(3),SIZE)+1;
                            current(1) = current(1)+1;
                            %disp(current(1));
                        elseif (current(1) > destination (1))
                            rxlink(current(1),current(2),current(3),SIZE)=rxlink(current(1),current(2),current(3),SIZE)+1;
                            current(1) = current(1)-1;
                            %disp(current(1));
                        
                        else % equal
                            break;
                        end
                    end
                end
            end
            
            c=2; %matrix B
            current = [a,b,3];
            for k=1:SIZE
                destination = [a,k,2];
                while (current(1) ~= destination(1) || current(2) ~= destination(2) || current(3) ~= destination(3))         
                    if (current(3) < destination (3))
                        zlink(current(1),current(2),current(3),SIZE)=zlink(current(1),current(2),current(3),SIZE)+1;
                        current(3) = current(3)+1;
                    elseif (current(3) > destination (3))
                        rzlink(current(1),current(2),current(3)-1,SIZE)=rzlink(current(1),current(2),current(3)-1,SIZE)+1;
                        current(3) = current(3)-1;
                    else % equal
                        %disp(current(1));
                        if (current(2) < destination (2))
                            ylink(current(1),current(2),current(3),SIZE)=ylink(current(1),current(2),current(3),SIZE)+1;
                            current(2) = current(2)+1;
                            %disp(current(2));
                        elseif (current(2) > destination (2))
                            rylink(current(1),current(2),current(3),SIZE)=rylink(current(1),current(2),current(3),SIZE)+1;
                            current(2) = current(2)-1;
                            %disp(current(2));
                        else % equal
                            if (current(1) < destination (1))
                                xlink(current(1),current(2),current(3),SIZE)=xlink(current(1),current(2),current(3),SIZE)+1;
                                current(1) = current(1)+1;
                                %disp(current(1));
                            elseif (current(1) > destination (1))
                                rxlink(current(1),current(2),current(3),SIZE)=rxlink(current(1),current(2),current(3),SIZE)+1;
                                current(1) = current(1)-1;
                                %disp(current(1));

                            else % equal
                                break;
                            end
                        end
                    end
                end
            end
            
            
        end
    end
end
% 
%for SIZE=3:3
SIZE=10;
    %subplot(3,1,SIZE);
    %imagesc(xlink(:,:,SIZE))
    for  i=1:SIZE
        for j=1:SIZE
            for l=1:3
            data(i,j,l)=xlink(i,j,l,SIZE)+rxlink(i,j,l,SIZE)+ylink(i,j,l,SIZE)+rylink(i,j,l,SIZE)+zlink(i,j,l,SIZE)+rzlink(i,j,l,SIZE);
            end
        end    
    end

subplot(1,3,1);
bh1=bar3(data(:,:,1));
set(bh1,'FaceColor',[0.9 0.2 0.1]);
xlabel({'x index'});
ylabel({'y index'});
zlabel({'number of communication'});
title('Layer 1');

subplot(1,3,2);
bh1=bar3(data(:,:,2));
set(bh1,'FaceColor',[0.3 .8 0.2]);
xlabel({'x index'});
ylabel({'y index'});
zlabel({'number of communication'});
title('Layer 2');

subplot(1,3,3);
bh1=bar3(data(:,:,3));
set(bh1,'FaceColor',[0.4 0.4 .9]);
xlabel({'x index'});
ylabel({'y index'});
zlabel({'number of communication'});
title('Layer 3');

%hold on;
%end




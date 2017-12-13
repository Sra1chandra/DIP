function [frame] = rippleTransform(image_name,ax,ay,tx,ty)
    % usage rippleTransform('bell.jpg',10,15,120,150);
    % ax,ay -> ripple amplitude tx,ty->frequency of ripples
    imgToEmbed=double(imread(image_name));
    frame=zeros(size(imgToEmbed));
    [dimx,dimy,Z]=size(imgToEmbed);
%     ax=10;ay=15;tx=120;ty=150;
    for k=1:Z
        for i=1:dimx
            for j=1:dimy
    %             x=i;y=j;
                x=i+ax*sin((2*pi*j)/tx);y=j+ay*sin((2*pi*i)/ty);
                if (~(isinteger(x) && isinteger(y))) % if both coordinates are not integers
                    %bilinearly interpolate
                    x_dash = floor(x);
                    y_dash = floor(y);
                    x_bar = x_dash + 1;      
                    y_bar = y_dash + 1;

                    Ex_bar = x_bar - x;
                    Ey_bar = y_bar - y;
                    Ex_dash = x - x_dash;
                    Ey_dash = y - y_dash;
                    if((x_dash > 0) && (x_bar < dimx) && (y_dash > 0) && (y_bar < dimy))
                        tmp = Ex_bar * Ey_bar * imgToEmbed(x_dash,y_dash,k);
                        tmp = tmp + Ex_dash * Ey_bar * imgToEmbed(x_bar,y_dash,k);
                        tmp = tmp + Ex_bar * Ey_dash * imgToEmbed(x_dash,y_bar,k);
                        tmp = tmp + Ex_dash * Ey_dash * imgToEmbed(x_bar,y_bar,k);
        %                 tmp=imgToEmbed(round(y),round(x),k);
                        frame(i,j,k) = tmp;
                    end
                else
                    frame(i,j,k) = imgToEmbed(x, y, k);
                end
            end
        end
    end
    figure;
    subplot(1,2,1);
    imshow(uint8(imgToEmbed));title('Orginal Image');
    subplot(1,2,2);
    imshow(uint8(frame));title('Transformed Image')
end
function [frame] = sphericalTransform(image_name,xc,yc,rmax,u)
    % usage sphericalTransform('bell.jpg',240,420,150,0.8);
    % xc,yc-> center ,rmax -> radius ,u -> refractive Index
    imgToEmbed=double(imread(image_name));
    frame=zeros(size(imgToEmbed));
    [dimx,dimy,Z]=size(imgToEmbed);

    for k=1:Z
        for i=1:dimx
            for j=1:dimy
                x=i;y=j;
                r=sqrt((i-xc)^2+(j-yc)^2);
                if(r<rmax)
                    z=sqrt(rmax^2-r^2);
                    bx=(1-1/u)*asin((x-xc)/sqrt(((x-xc)^2)+z^2));
                    by=(1-1/u)*asin((y-yc)/sqrt(((y-yc)^2)+z^2));
                    x=x-z*tan(bx);
                    y=y-z*tan(by);
                end
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
    imshow(uint8(frame));title('Transformed Image');
end
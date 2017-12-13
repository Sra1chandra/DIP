function []=local_histogram_equalization(image_name)
    % usage local_histogram_equalization('hist_equal2.jpg');
    img1=rgb2gray(imread(image_name));
    [X,Y,Z]=size(img1);
    patch1=floor(X/6);
    patch2=floor(Y/6);    
    img2=img1;
    n=256;
    cumulative_matrix = tril(ones(n,n),0);
    for k=1:Z
        i=1;
        while(i+patch1 < X)
            j=1;
            while(j+patch2<Y)
                X1=imhist(img1(i:i+patch1-1,j:j+patch2-1,k),n);
                N=sum(X1);
                %N==patch*patch
                initial_cumulative_sum = round(((cumulative_matrix*X1)*(n-1))/(patch1*patch2));
                img3=img1(i:i+patch1-1,j:j+patch2-1,k);
                
                for z=1:n
                    temp=find(img1(i:i+patch1-1,j:j+patch2-1,k)==(z-1));
                    if ~isempty(temp)
                        img3(temp)=initial_cumulative_sum(z);
                    end
                end
                img2(i:i+patch1-1,j:j+patch2-1)=img3;
                j=j+patch2;
            end
            i=i+patch1;
        end
    end
    figure;
    subplot(2,2,1);
    imshow(img1);
    subplot(2,2,2);
    imshow(uint8(img2));
    subplot(2,2,3);
    imhist(img1);
    subplot(2,2,4);
    imhist(img2);
end
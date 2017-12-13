function []=histogram_equalization(image_name)
    % usage histogram_equalization('hist_equal3.jpg');
    img1=rgb2gray(imread(image_name));
    img2=img1;
    n=256;
    cumulative_matrix = tril(ones(n,n),0);
    for j=1:1
        X1=imhist(img1(:,:,j),n);
        N=sum(X1);
        initial_cumulative_sum = round(((cumulative_matrix*X1)*(n-1))/N);
        img3=img1(:,:,j);
        for i=1:n
            temp=find(img1(:,:,j)==(i-1));
            if ~isempty(temp)
                img3(temp)=initial_cumulative_sum(i).*ones(1,size(temp,1));
            end
        end
        img2(:,:,j)=img3;
    end
    figure;
    subplot(1,2,1);
    imshow(img1);title('Orginal image');
    subplot(1,2,2);
    imshow(img2,[]);title('Transformed image');
end
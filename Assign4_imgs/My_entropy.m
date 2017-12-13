function [ output ] = My_entropy( img )
[M,N]=size(img);
p=imhist(img);
i=1;
sum=0;
while i<=256
    if p(i)~=0
        p(i)
        sum=sum-(p(i)/(M*N))*log2(p(i)/(M*N));
    end
    i=i+1;
end
output=sum;
end


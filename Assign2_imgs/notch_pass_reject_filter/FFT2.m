function [F]=FFT2(a)
    % usage imshow(FFT2(double(imread('cameraman.tif'))));
    % Note : image size should be square and a power of 2;
    [~,N]=size(a);
    if N==1
        F=a;
    else
        a_even_even=FFT2(a(1:2:end,1:2:end));
        a_even_odd=FFT2(a(1:2:end,2:2:end));
        a_odd_even=FFT2(a(2:2:end,1:2:end));
        a_odd_odd=FFT2(a(2:2:end,2:2:end));

        Q1=exp(-2*pi*1i*(repmat((0:N/2-1)',1,N/2)')./N);
        Q2=exp(-2*pi*1i*(repmat((0:N/2-1),N/2,1)')./N);
        Q3=Q1.*Q2;

        F1=a_even_even;
        F2=a_even_odd.*Q1;
        F3=a_odd_even.*Q2;
        F4=a_odd_odd.*Q3;
        F=[(F1+F2+F3+F4) (F1-F2+F3-F4);(F1+F2-F3-F4) (F1-F2-F3+F4)];
    end
end
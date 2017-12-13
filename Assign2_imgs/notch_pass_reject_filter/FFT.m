function [F]=FFT(a)
    N=size(a,2);
    if N==1
        F=a;
    else
        a_even=FFT(a(1:2:end));
        a_odd=FFT(a(2:2:end));
        Q=exp(-2*pi*1i*((0:N/2-1)')./N);
        temp=Q.*a_odd;
        F=[(a_even+temp);(a_even-temp)];
    end
end
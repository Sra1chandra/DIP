function [output] = myDCT_quantization(imDCT,qm,c)
    output=int16(imDCT./(qm*c));
    % output=imDCT;
end


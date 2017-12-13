function [ output ] = myDCT_dequantization( imqDCT,qm,c )
    output=imqDCT.*(qm*c);
    % output=imqDCT;
end
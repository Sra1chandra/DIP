%    slope = (x2-x1)/(y2-y1);
%    yRight = rows; % x is on the reight edge.
%    xRight = slope * (yRight - y1) + x1;



req_img=zeros(rows,columns);
if vanishing_pointx>columns/2
    x1=min(s.x);
    y1=rows;
    x2=vanishing_pointx;
    y2=vanishing_pointy;
%     a=y2-y1;
%     b=x1-x2;
%     slope=-a/b;
%     c=y1-x1*slope;
    [cx,cy,~]=improfile(~Ie,[x1 vanishing_pointx],[rows vanishing_pointy]);
    cx=round(cx);
    cy=round(cy);
    intensity=1;
    offset=1/size(cx,1);
    for i=1:size(cx,1)
        req_img(1:cy(i),cx(i))=intensity;
        req_img(cy(i),cx(i):end)=intensity;
        intensity=intensity-offset;
        if cx(i)>=columns
            break;
        end
    end
end

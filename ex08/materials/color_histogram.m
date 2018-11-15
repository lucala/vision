function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
    [sY,sX,~] = size(frame);
    xMin = int32(xMin);
    xMax = int32(xMax);
    yMin = int32(yMin);
    yMax = int32(yMax);
    hist = zeros(hist_bin,hist_bin,hist_bin);
    c = 0;
for x = xMin:xMax
    if x <= sX && x >= 1
        for y = yMin:yMax
            if y <= sY && y >= 1
                c = c +1;
                t = ceil(double(frame(y,x,:)+uint8(ones(1,1,3))) * double(hist_bin/256));
                hist(t(1), t(2), t(3)) = hist(t(1), t(2), t(3))+1;
            end
        end
    end
end 

if c > 0
    hist = hist./c;
end

end

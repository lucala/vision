function [in1, in2, out1, out2, m, Fh] = ransac8pF(xy1, xy2, threshold)
if true
    %use adaptive ransac, defined below
    [in1, in2, out1, out2, m, Fh] = adaptiveRansac(xy1, xy2, threshold);
else
    %use normal ransac
    in1=0;
    in2=0;
    out1=0;
    out2=0;
    Fh=0;
    %m = number iterations
    m = 0;

    number = size(xy1, 2);
    bestInNum = 0;
    nrTotalInliers = 0;
    for i=1:1000
     %choose 8 random points
     y = randsample(number, 8);
     p1 = xy1(:,y);
     p2 = xy2(:,y);
     [Fh, F] = fundamentalMatrix(cart2hom(p1')', cart2hom(p2')');


     err = zeros(number,1);
     for j=1:number
        p1j = xy1(:,j);
        p2j = xy2(:,j);
        err(j) = distPointLine(p2j, Fh*cart2hom(p1j')') + distPointLine(p1j, Fh'*cart2hom(p2j')');
     end

        inliers = find(err<=threshold);
        outliers = find(err>threshold);
        nrInliers = length(inliers);



        % Update the number of inliers and fitting model if better model is found
        if (nrInliers > bestInNum)
            in1 = xy1(:,inliers);
            in2 = xy2(:,inliers);
            out1 = xy1(:,outliers);
            out2 = xy2(:,outliers);
            bestInNum = nrInliers;
        end


    end
end

end
function [in1, in2, out1, out2, m, Fh] = adaptiveRansac(xy1, xy2, threshold)
    in1=0;
    in2=0;
    out1=0;
    out2=0;
    Fh=0;
    %m = number iterations
    m = 0;

    number = size(xy1, 2);
    bestInNum = 0;
    nrTotalInliers = 0;
    counter = 0;
    while(true)
     %choose 8 random points
     y = randsample(number, 8);
     p1 = xy1(:,y);
     p2 = xy2(:,y);
     [Fh, F] = fundamentalMatrix(cart2hom(p1')', cart2hom(p2')');


     err = zeros(number,1);
     for j=1:number
        p1j = xy1(:,j);
        p2j = xy2(:,j);
        err(j) = distPointLine(p2j, Fh*cart2hom(p1j')') + distPointLine(p1j, Fh'*cart2hom(p2j')');
     end

        inliers = find(err<=threshold);
        outliers = find(err>threshold);
        nrInliers = length(inliers);
        nrOutliers = length(outliers);


        % Update the number of inliers and fitting model if better model is found
        if (nrInliers > bestInNum)
            in1 = xy1(:,inliers);
            in2 = xy2(:,inliers);
            out1 = xy1(:,outliers);
            out2 = xy2(:,outliers);
            bestInNum = nrInliers;
        end
        

        r = bestInNum/(nrInliers+nrOutliers);
        n = nTrials(r,8,0.99);
        if counter > n
            break;
        end
        counter = counter+1;
    end
    m = counter;
end



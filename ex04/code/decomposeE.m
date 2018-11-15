% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% Yu will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1s, x2s)
    [U,S,V] = svd(E);
    t = U(:,end);
    t = t/norm(t);
    
    W = [0 -1 0; 1 0 0; 0 0 1];
    R1 = U*W*V';
    R2 = U*W'*V';
    if det(R1) < 0
        R1 = -R1;
    end
    if det(R2) < 0
        R2 = -R2;
    end
    P1 = [R1 t];
    P2 = [R1 -t];
    P3 = [R2 t];
    P4 = [R2 -t];
    
    
    Ps = [eye(3), zeros(3,1)];

    [Xs1, err] = linearTriangulation(Ps, x1s, P1, x2s);
    [Xs2, err] = linearTriangulation(Ps, x1s, P2, x2s);
    [Xs3, err] = linearTriangulation(Ps, x1s, P3, x2s);
    [Xs4, err] = linearTriangulation(Ps, x1s, P4, x2s);

    
    tmp1 = P1*Xs1;
    tmp2 = P2*Xs2;
    tmp3 = P3*Xs3;
    tmp4 = P4*Xs4;
    if tmp1(3,1) > 0 && Xs1(3) > 0
        P = P1;
        X = Xs1;
    elseif tmp2(3,1) > 0 && Xs2(3) > 0
        P = P2;
        X = Xs2;
    elseif tmp3(3,1) > 0 && Xs3(3) > 0
        P = P3;
        X = Xs3;
    else
        P = P4;
        X = Xs4;
    end
    

    scatter3(X(1,:),X(2,:),X(3,:));
    %show all cameras
    showCameras(mat2cell([Ps; 0 0 0 1],4,4),10);
    showCameras(mat2cell([P1; 0 0 0 1],4,4),10);
    showCameras(mat2cell([P2; 0 0 0 1],4,4),10);
    showCameras(mat2cell([P3; 0 0 0 1],4,4),10);
    showCameras(mat2cell([P4; 0 0 0 1],4,4),10);
    scatter3(X(1,:),X(2,:),X(3,:));
    
    %show selected camera and reference camera
    showCameras(mat2cell([P; 0 0 0 1],4,4),20);
    showCameras(mat2cell(eye(4),4,4),20);
    scatter3(X(1,:),X(2,:),X(3,:));
    
end
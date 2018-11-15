function vPoints = grid_points(img,nPointsX,nPointsY,border)
    [height,width] = size(img);
    
    stepsizeX = floor(width/nPointsX);
    stepsizeY = floor(height/nPointsY);
    [x,y] = meshgrid(border:stepsizeY:(height-border),border:stepsizeX:(width-border));
    
    vPoints = [x(:) y(:)];

end

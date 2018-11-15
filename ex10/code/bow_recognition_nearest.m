function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor in the positive and negative sets
  % and decide based on this neighbor
  [~,dPos] = findnn(histogram,vBoWPos);
  [~,dNeg] = findnn(histogram,vBoWNeg);
%   DistPos = min(dPos);
%   DistNeg = min(dNeg);
  DistPos = dPos;
  DistNeg = dNeg;
  
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end

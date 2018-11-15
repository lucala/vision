function [particles, particles_w] = resample( particles,particles_w )

newParticles = zeros(size(particles,1),size(particles,2));
newParticles_w = zeros(length(particles_w),1);

for i=1:size(particles,1)
    ind = datasample(1:length(particles_w),1,'Weights',particles_w);
    newParticles(i,:) = particles(ind,:);
    newParticles_w(i) = particles_w(ind);
end
 
particles = newParticles;
particles_w = newParticles_w./sum(newParticles_w);
end
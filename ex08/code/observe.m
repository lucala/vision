function particles_w = observe(particles, frame, H, W, hist_bin, hist_target, sigma_observe)

particles_w = zeros(size(particles,1),1);
for i=1:size(particles,1)
    center = [particles(i,1); particles(i,2)];
    hist = color_histogram(center(1)-W/2,center(2)-H/2,center(1)+W/2,center(2)+H/2,frame,hist_bin);
    dist = chi2_cost(hist_target, hist);
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe)*exp(-dist.^2/(2*sigma_observe^2));
end

particles_w = particles_w./sum(particles_w);

end
function particles = propagate(particles, sizeFrame, params)
    particles = particles';
    if(params.model == 0)
        %no motion
        tmpParticles = zeros(2,size(particles,2));
        for i=1:size(particles,2)
            rx = normrnd(particles(1,i),params.sigma_position);
            ry = normrnd(particles(2,i),params.sigma_position);
            %A = [1 0 rx; 0 1 ry];
            %tmpParticles(:,i) = A*particles(:,i);
            tmpParticles(:,i) = [rx;ry];
            if(tmpParticles(1,i) < 1)
                tmpParticles(1,i) = 1;
            end
            if(tmpParticles(1,i) > sizeFrame(2))
                tmpParticles(1,i) = sizeFrame(2);
            end
            if(tmpParticles(2,i) < 1)
                tmpParticles(2,i) = 1;
            end
            if(tmpParticles(2,i) > sizeFrame(1))
                tmpParticles(2,i) = sizeFrame(1);
            end
        end
    else
        %constant motion
        tmpParticles = zeros(4,size(particles,2));
        for i=1:size(particles,2)
            rx = normrnd(particles(1,i),params.sigma_position);
            ry = normrnd(particles(2,i),params.sigma_position);
            vx = normrnd(particles(3,i),params.sigma_velocity);
            vy = normrnd(particles(4,i),params.sigma_velocity);
            %A = [1 0 rx; 0 1 ry];
            tmpParticles(1:4,i) = [rx+particles(3,i);ry+particles(4,i);vx;vy];
            if(tmpParticles(1,i) < 1)
                tmpParticles(1,i) = 1;
            end
            if(tmpParticles(1,i) > sizeFrame(2))
                tmpParticles(1,i) = sizeFrame(2);
            end
            if(tmpParticles(2,i) < 1)
                tmpParticles(2,i) = 1;
            end
            if(tmpParticles(2,i) > sizeFrame(1))
                tmpParticles(2,i) = sizeFrame(1);
            end

            %A = [1 0 vx; 0 1 vy];
            %tmpParticles(3:4,i) = A*particles(3:4,i);
        end
    end

    particles = tmpParticles';
end
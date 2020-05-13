function [u,v,w] = ytla_uvw(xPos, yPos, skypol, mFreq)
    % xPos, yPos: antenna position on the platform, in cm
    %	size = (1, nAnts)
    % skypol: platform orientation wrt ra/dec in deg
    %	size = (nTime, 1)
    % mFreq: central RF in Hz
    %	size = (1, 1)

    nTime = size(skypol, 1);
    nAnts = size(xPos, 2);
    nBase = nAnts * (nAnts - 1) / 2;
    speedC = 29979245800;	% CGS
    lambda = speedC / mFreq;	% in cm

    spcorr = -8.0;		% skypol correction in deg
    th = (skypol + spcorr - 180.) / 180. * pi;
    rot = zeros(2,2,nTime);
    rot(1,1,:) =  cos(th);
    rot(1,2,:) = -sin(th);
    rot(2,1,:) =  sin(th);
    rot(2,2,:) =  cos(th);

    antXY  = cat(1, xPos, yPos);	% size:(2,nAnts)
    antXY2 = zeros(nTime, 2,nAnts);
    for idx = 1:nTime
	antXY2(idx,:,:) = rot(:,:,idx) * antXY;
    end

    u = zeros(nTime, nBase);
    v = zeros(nTime, nBase);
    w = zeros(nTime, nBase);	% w is fixed to zero for YTLA

    idx = 0;
    for ai = 1:nAnts-1
	for aj = ai+1:nAnts
	    idx = idx + 1;

	    u(:,idx) = antXY2(:,1,aj) - antXY2(:,1,ai);
	    v(:,idx) = antXY2(:,2,aj) - antXY2(:,2,ai);
	end
    end

    % use B/(lambda/1cm)? --> wrong
    % use B/1cm
    %u = u / lambda;
    %v = v / lambda;

end


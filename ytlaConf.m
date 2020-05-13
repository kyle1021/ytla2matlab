nAnts  = 7;
nBase  = nAnts * (nAnts-1) / 2;
nChan  = 1024;
nWin   = 2;
nPlat  = 1;

bw0    = 2240.;		    % MHz
delFreq = bw0/nChan*1e6 ;   % Hz

%% ytla7-1.4m config
xPos = zeros(1,nAnts);
yPos = zeros(1,nAnts);
sep = 140.;	%cm
th0 = 60.;	%deg, ccw from X-axis
for idx = 1:nAnts
    if (idx == 1)
	xPos(1) = 0.;
	yPos(1) = 0.;
    else
	th = th0 - 60. * (idx-2);
	xPos(idx) = sep * cos(th/180.*pi);
	yPos(idx) = sep * sin(th/180.*pi);
    end
end

antPlatOffset = cat(1,xPos,yPos,zeros(1,nAnts));

%% site info
mlo = struct(...       
	'long', -155.5753, ...	% longitude, deg
	'lat', 19.5363, ...     % latitude, deg
	'alt', 3426.0 ...       % height, m
	);


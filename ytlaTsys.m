function Tsys = ytlaTsys(ytla, varargin)
    % given a ytla structure (from ytlaLoadh5)
    % convert the variance data into Tsys
    % assuming a fiducial efficiency of 0.5
    % the same efficiency is passed to antenna info


    % ytla params
    run('ytlaConf.m');

    % some defaults
    chmin = 20;
    chmax = 720;
    aeff  = 0.5;    % aperture efficiency; aeff = 0.5 corresponds to approx. jyperk = 1MJy/200K = 5000
    arad  = 0.6;    % antenna radius in meters
    jyperk = 2 * 1.38e3 / aeff / (pi * arad^2);


    % Process optional arguments
    nvar = numel(varargin);
    if (mod(nvar,2)==0)
        for idx=1:2:numel(varargin)
            tempVal = varargin{idx+1};
            eval([varargin{idx}, '=tempVal;'])
            clear tempVal;
        end
    else
        fprintf('varargin should come in pairs.\n')
        return
    end

    % obtain relevant data
    [nTime, nBase, nWin, nChan] = size(ytla.cross);
    flag = ytla.flag;	    % 0 means good data
    var  = ytla.variance;   % in units of Jy^2
    
    delta_nu = bw0 * 1e6 / nChan;

    bflag = median(flag(:,:,:,chmin:chmax), 4);	    % a per-baseline flag
    bvar  = median(real(var(:,:,:,chmin:chmax)), 4) + median(imag(var(:,:,:,chmin:chmax)), 4);
    bvar  = bvar / 2;				    % a per-baseline variance in Jy^2

    Tsys = zeros(nTime, nAnts, nWin);

    for ti=1:nTime
	tint = ytla.pnt.tint(ti);
	for wi=1:nWin
	    M = zeros(nBase, nAnts);
	    D = zeros(nBase, 1);
	    % will solve X from M . X = D
	    % X = Minv . D
	    bi = 0;
	    for a1=1:nAnts-1
		for a2=a1+1:nAnts
		    bi = bi + 1;
		    if bflag(ti,bi,wi)==0	%ok
			M(bi,a1) = 0.5;
			M(bi,a2) = 0.5;
			D(bi) = log(bvar(ti,bi,wi));
		    end
		end
	    end

	    Minv = pinv(M);
	    X = Minv * D;    % log(var)
	    w = abs(X) < 1e-3;
	    avar = exp(X);   % var
	    avar(w) = 0;     % zero out invalid solution
	    for ai=1:nAnts
		Tsys(ti,ai,wi) = sqrt(avar(ai) .* (delta_nu * tint));
	    end
	end
    end

    Tsys = Tsys / jyperk;

end



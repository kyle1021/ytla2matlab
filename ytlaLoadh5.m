function ytla=ytlaLoadh5(fileName)

    try
	lomhz = h5readatt(fileName, '/', 'LOFreq');
    catch
	try
	    lomhz = h5readatt(fileName, '/', 'LO');
	catch
	    lomhz = 0.;
	    disp('could not read LO freq from h5 file!');
	end
    end
    %fprintf('LO = %d MHz\n', lomhz)

    time = h5read(fileName, '/time');
    cross = h5read(fileName, '/cross');
    vari = h5read(fileName, '/variance');
    flag = h5read(fileName, '/flag');
    pnt0 = h5read(fileName, '/pointing');
    pnthdr = h5read(fileName, '/pnt_header');
    blmeter = h5read(fileName, '/blmeter');

    cVis = permute(cross.r + 1.j*cross.i, [1,3,4,2]);	% convert from input compound to complex
							% and reorder index as
							% visStruc.cross: (nTime, nBase, nWin, nChan)
    cVar = permute(vari.r + 1.j*vari.i, [1,3,4,2]);	% convert from input compound to complex

    [nTime, nch, nb, nsb] = size(flag);
    na = 0.5 + sqrt(2.*nb+0.25);
    try
	poffset = h5read(fileName, '/poffset');
    catch
	poffset = zeros(nTime, 2);
    end
    try
        auto = h5read(fileName, '/auto');
    catch
	auto = ones(nTime, nch, na, nsb);
    end
    try
	target = h5read(fileName, '/target');
    catch
	target = cell(nTime, 1);
    end

    pntStruc = struct();
    cpnthdr = char(pnthdr);
    [ncol, nwd] = size(cpnthdr);
    for idx = 1:ncol
	pntStruc.(strtrim(strcat(cpnthdr(idx,:)))) = pnt0(:,idx);
    end
    pntStruc.tint = pnt0(:,4) - pnt0(:,3);

    ytla = struct(  'LO', lomhz, ...
		    'epochTime', time, ...
                    'auto', permute(auto, [1,3,4,2]), ...
		    'cross', cVis, ...
		    'variance', cVar, ...
		    'flag', permute(flag, [1,3,4,2]), ...
		    'pntarr', pnt0, ...
		    'pnthdr', cpnthdr, ...
		    'pnt', pntStruc, ...
		    ...%'target', target, ...
		    'blmeter', blmeter );
		    %'dummy', 'dummy');
    ytla.target = target;


end


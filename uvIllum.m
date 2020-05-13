function illumPattern = uvIllum(gridRes,gridSize,antType,varargin)
% (old) illum=uvIllum(uGrid,vGrid,lambda,antType)
%
% gridRes is in units of cm
% gridSize is in number of pixels
% antType is defined for OVRO, BIMA and SZA.
%
% Written: DPM Jan 2012
% Stolen: GKK Oct 2012
antScale = 1;
overSamp = 1;
antInfo = [];
illumOffset = [0 0];

if not(exist('antType','var'))
    antType='SZA';
elseif isnumeric(antType)
    antType='SZA';
end

for idx=1:2:numel(varargin)
    tempVal = varargin{idx+1}; %#ok
    eval([varargin{idx},'=tempVal;'])
    clear tempVal
end

if eq(overSamp,1)
    vGrid = repmat((-floor(gridSize/2):floor((gridSize-1)/2)).*gridRes,[gridSize 1]);
    uGrid = repmat(permute((-floor(gridSize/2):floor((gridSize-1)/2)).*gridRes,[2 1]),[1 gridSize ]);
else
    vGrid = repmat(reshape((-floor(overSamp*gridSize/2):floor((overSamp*gridSize-1)/2)).*...
        (gridRes/overSamp),overSamp,1,gridSize),[1 overSamp 1 gridSize]);
    uGrid = reshape(permute(vGrid,[2,1,4,3]),overSamp^2,gridSize,gridSize);
    vGrid = reshape(vGrid,overSamp^2,gridSize,gridSize);    
end
%%%%% Create Efield illumination patterns for the four dishes
%%%%% See CARMA Memo 50
% Taper: J0(j_01*r/r_0)
%  Design tapers
%  OVRO  = 9.7dB Bessel
%  BIMA  = 9.8dB Bessel
%  ALMA  = 11.0dB Gaussian (design spec)
%  VLA   = 00.0dB Uniform
%  AMiBA = 11.6dB Bessel (assumed)
%  SZA   = 11.6dB Bessel (JWL email with MKS)
%  SMA   = 10.0dB Bessel (GKK discussion w/ TKS)
%  j_01  = first null = 2.40483
J01=2.40483;

if isempty(antInfo)
    antInfo = info_antenna(antType);
end

R0 = antInfo.taperRadius.*antScale;
R1 = antInfo.priRadius.*antScale;
R2 = antInfo.secRadius.*antScale;

if eq(overSamp,1)
    illumPattern=zeros(gridSize,gridSize);
else
    illumPattern=zeros(overSamp^2,gridSize,gridSize);
end

distGrid = sqrt((uGrid.^2)+(vGrid.^2));
gridMask = and(le(distGrid,min(R0,R1)),ge(distGrid,R2));

if not(all(eq(illumOffset,0)))
    distGrid = sqrt((uGrid+illumOffset(1)).^2 + (uGrid+illumOffset(1)).^2);
end


switch antInfo.taperType
    case 'Bessel'
        illumPattern(gridMask) = ...
            besselj(0,distGrid(gridMask).*(J01./R0));
    case 'Gaussian'
	% assuming Gaussian illumPattern = exp(log(0.5)*(r/R0)^2)
	% the 'taper radius' r0 can be related to the edge taper Te (in dB) as
	% R0 = R1 * sqrt((20*log2) / (Te*log10))
	% R1 is the primary radius
	%
	% example Te: 11.0 (ALMA), 10.5 (YTLA)
	% for Te = 11.0
	% the taper radius R0 = R1 * 0.74
	% is smaller than the primary radius
	% therefore, we need to re-define outer cutoff radius at R1, not min(R0,R1)
	gridMask = and(le(distGrid,R1),ge(distGrid,R2));
        illumPattern(gridMask) = ...
            exp(log(0.5).*(distGrid(gridMask).*(1/R0)).^2);
    case 'Uniform'
        illumPattern(gridMask) = 1;
end
if ne(overSamp,1)
    illumPattern = shiftdim(sum(illumPattern,1),1).*(overSamp^(-2));
end
%illumPattern(uvr_m<R2)=0;
%illumPattern(uvr_m>R1)=0;
end

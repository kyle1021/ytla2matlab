%modelStruc = gen_specsources('zRange',[0.195 0.253],'boxSize',[(10/60)*(pi/180) 0],'souDensity',1,'transName','CO(1-0)');
%visStruc = vis_gen('ytla7-1.2m','YTLA4GHz','obsFreq',94e9,'nHours',8,'haRange',[-4 4],'decApp',0,'modelStruc',modelStruc);

obsFreq = 94e9;
visStruc = vis_gen('ytla7-1.2m','YTLA4GHz','obsFreq',obsFreq,'nHours',800,'haRange',[-4 4],'nTime',48);

%% flag out BF>1.5GHz (ch700 in YTLA)
freq = visStruc.metaData.freq;
new_flag = visStruc.flags.spur;

freq_sel = gt(abs(freq-obsFreq), 1.5e9);
new_flag(:,:,:,freq_sel) = new_flag(:,:,:,freq_sel) + 64;
freq_sel = lt(abs(freq-obsFreq), 50e6);
new_flag(:,:,:,freq_sel) = new_flag(:,:,:,freq_sel) + 64;

%% remove bad antennas
ant1Arr = visStruc.metaData.ant1Arr;
ant2Arr = visStruc.metaData.ant2Arr;
bad_ant = [2];
for idx=1:numel(bad_ant)
    ai = bad_ant(idx);
    ant_sel = or(eq(ant1Arr,ai), eq(ant2Arr,ai));
    new_flag(:,ant_sel,:,:) = new_flag(:,ant_sel,:,:) + 128;
end

%% update the flagging
visStruc.flags.spur = new_flag;


kGridStruc = KGrid_Data('build',visStruc);
powSpec = PowSpec_Data(kGridStruc,'transName','CO(3-2)');
plot_powspec(powSpec.delFinVal,powSpec.delFinErr,powSpec.kModes,'Tint=800hrs',0,'sim_800hr.png','plotVisible=true');

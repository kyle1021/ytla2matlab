modelStruc = gen_specsources('zRange',[0.195 0.253],'boxSize',[(10/60)*(pi/180) 0],'souDensity',1,'transName','CO(1-0)');
visStruc = vis_gen('ytla7-1.2m','1GHz','obsFreq',94e9,'nHours',8,'haRange',[-4 4],'decApp',0,'modelStruc',modelStruc);
kGridStruc = KGrid_Data('build',visStruc);
powSpec = PowSpec_Data(kGridStruc,'transName','CO(1-0)');
plot_powspec(powSpec.delFinVal,powSpec.delFinErr,powSpec.kModes,'',0,'','plotVisible=true');

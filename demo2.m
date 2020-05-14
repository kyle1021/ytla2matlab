% q2343 power spectrum
fq2343 = 'q2343/q2343_lead-on.ytla7X.mrgh5';
visQ2343 = ytlaImport('blank', fq2343, 'q2343', 'S')
kGridQ2343 = KGrid_Data('build', visQ2343)
psQ2343 = PowSpec_Data(kGridQ2343, 'transName', 'CO(1-0)')
plot_powspec(psQ2343.delFinVal, psQ2343.delFinErr, psQ2343.kModes, '', 0, '', 'plotVisible=true');


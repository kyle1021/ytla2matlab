% jupiter image
fjup = 'jupiter/jupiter-a.ytla7X.mrgh5';
%visJupiter = ytlaImport('test', fjup, 'jupiter', 'S', 'hostName', 'coma18')
%imgJupiter = Image_Data('norm', visJupiter, 'full', 'imCellSize', 10, 'FoV', 1200, 'hostName', 'coma18')
visJupiter = ytlaImport('test', fjup, 'jupiter', 'S')
imgJupiter = Image_Data('norm', visJupiter, 'full', 'imCellSize', 10, 'FoV', 1200)
dirtyPeak = max(imgJupiter.dirtyImage(:));
imshow(imgJupiter.dirtyImage/dirtyPeak);
fits_write('IMG', imgJupiter, 'jupiter/mat_jupiter.fits')


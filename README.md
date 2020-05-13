# ytla2matlab

This is a tool to import YTLA reduced data (.mrgh5 files) into a data struct that can work with Karto's Matlab pipeline.

example:
   visStruc = ytlaImport('test', 'jupiter-a.ytla7X.mrgh5', 'jupiter', 'S')
   
   Four required arguments by order:
   dataName: an arbitrary name of the observation group --> 'test'
   fileName: the ytla data file --> 'jupiter-a.ytla7X.mrgh5'
   souName:  the source name --> 'jupiter'
   purpLab:  the purpose label --> 'S'
             (choices: 'S' for science, 'G' for Gain cal, 'B' for bandpass cal, 'F' for flux cal)
             

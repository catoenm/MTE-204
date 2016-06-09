clc
close all
clear all

KGLOBAL = [1 -1;
           -1 1];

CGLOBAL = [ .1 -.1;
            -.1 .1];

MGLOBAL = [ 0, 0;
            0, 0.01];

FGLOBAL = [NaN; 1];

UGLOBAL = [0; 0];

UDOTGLOBAL = [0; 0];

UDDOTGLOBAL = [0;0];

PREVUGLOBAL = [0;0];

FIXED = [1];

FREE = [2];

OPTION = 2;

TIME = 0.1;

[U,F] = solveMCKU( KGLOBAL, MGLOBAL, CGLOBAL,... 
         FGLOBAL, UGLOBAL, UDOTGLOBAL, UDDOTGLOBAL, PREVUGLOBAL,...
         FIXED, FREE, OPTION, TIME, .25, .5)
     
     
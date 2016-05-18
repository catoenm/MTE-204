% This is a test file for solveKU.m. 
% It uses a Mixed Method LU Decomposition problem from Tutorial 1 of
% MTE204.

clear all
%clc

K_TEST = [  8, -1, -1, -2, -4;
            -1, 9, -3, 0, -5;
            -1, -3, 10, -2, -4;
            -2, 0, -2, 5, -1;
            -4, -5, -4, -1, 14
         ];
U_TEST = [0; NaN; NaN; 0.5; 1];
F_TEST = [NaN; 0; 5; NaN; NaN];
FREE_TEST = [2,3];
FIXED_TEST = [1,4,5];

[U,F] = solveKU(K_TEST,F_TEST,U_TEST,FIXED_TEST,FREE_TEST)
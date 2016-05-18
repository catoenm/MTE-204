% This is a test file for LU_decomp.m. 

clc;
clear all;
close all;

% Test case 1

A1 = [
    6, -2, 2, 4;
    0, -4, 2, 2;
    0, 0, 2, -5;
    0, 0, 0, -3
];

b1 = [16; -6; -9; -3];

% Test case 2

A2 = [
    1, 4, 1;
    1, 6, -1;
    2, -1, 2;
];

b2 = [7; 13; 5];

linsolve1 = linsolve(A1,b1)
LU1 = LU_decomp(A1,b1)

linsolve2 = linsolve(A2,b2)
LU2 = LU_decomp(A2,b2)

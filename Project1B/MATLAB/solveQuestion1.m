clc
clear all
close all

loadCurves = 'Input_Files/Question1/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question1/props_1.txt';
nodes = 'Input_Files/Question1/nodes_1.txt';
sctr = 'Input_Files/Question1/sctr_1.txt';

for i = 1:length(loadCurveFiles)
    disp(loadCurveFiles(i).name)
    [uGlobal, fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), 2)
end
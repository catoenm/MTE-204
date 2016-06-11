clc
clear all
close all

loadCurves = 'Input_Files/Question2/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question2/props_2.txt';
nodes = 'Input_Files/Question2/nodes_2.txt';
sctr = 'Input_Files/Question2/sctr_2.txt';

% change option to specify implicit or explicit dynamics with and without
% damping
option = 4;

for i = 1:length(loadCurveFiles)
    timeStamp = cputime;
    results(i).option = option;
    results(i).timeStep = loadCurveFiles(i).name(8:end);
    disp(results(i).timeStep);
    [results(i).uGlobal, results(i).fGlobal, results(i).uComplete] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    results(i).uGlobal
    results(i).fGlobal
    results(i).elapsedTime = cputime - timeStamp;
end

% save the values created
% then use postProcessQuestion2.m to post process these values

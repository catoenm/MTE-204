clc
clear all
close all

% load 100 load curves from omega = 0.1 to omega = 10
loadCurves = 'Input_Files/Question3/curves/frequencyRange/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question3/props_3.txt';
nodes = 'Input_Files/Question3/nodes_3.txt';
sctr = 'Input_Files/Question3/sctr_3.txt';

option = 2;

% Calculate the maximum acceleration
for i = 1:length(loadCurveFiles)
    results(i).option = option;
    omega(i) = str2num(loadCurveFiles(i).name(9:end-4));
    [results(i).uGlobal, results(i).fGlobal, results(i).UComplete] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    node2YDisp(i, :) = results(i).UComplete(4, :);
    node2yAccel(i,:) = diff(node2YDisp(i, :), 2)./0.0001;
    maxAccel(i) = max(node2yAccel(i,:))
end

figure;
plot(log10(omega),maxAccel);
xlabel('Frequency (log10(\omega))');
ylabel('Acceleration (mm/ms^2)');
title('Max accleration as a funciton of frequency:')
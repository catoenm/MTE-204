clc
clear all
close all

symbolSpec = '^*o.';
colorSpec = 'rbmk';

loadCurves = 'Input_Files/Question1/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question1/props_1.txt';
nodes = 'Input_Files/Question1/nodes_1.txt';
sctr = 'Input_Files/Question1/sctr_1.txt';

option = 2;

for i = 1:length(loadCurveFiles)
    results(i).option = option;
    results(i).timeStep = loadCurveFiles(i).name(8:end);
    [results(i).uGlobal, results(i).fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
end

figure;
hold on;
for i = 1:length(results)
    plot(i,results(i).uGlobal(2), strcat(colorSpec(i),symbolSpec(i)),'DisplayName',results(i).timeStep);
end

legend('show');
title('Question 1: Displacement of Node 2 Using Explict Dynamics');


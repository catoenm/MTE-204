clc
clear all
close all

symbolSpec = '^*o.';
colorSpec = 'rbmk';

loadCurves = 'Input_Files/Question3/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question3/props.txt';
nodes = 'Input_Files/Question3/nodes_3.txt';
sctr = 'Input_Files/Question3/sctr_3.txt';

% Options
% 1 - Implicit, no damping
% 2 - Implicit, with damping
% 3 - Explicit, no damping
% 4 - Explicit, with damping

% *************************************************************************
% Question 3d
% *************************************************************************

option = 1;

for i = 1:length(loadCurveFiles)
    explicitResults(i).option = option;
    timeSteps{i} = loadCurveFiles(i).name(8:end-4);
    [explicitResults(i).uGlobal, explicitResults(i).fGlobal, explicitResults(i).UComplete] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    explicitNode2Disp(1,i) = explicitResults(i).uGlobal(2);
end

figure
hold on

velocity = diff(explicitNode2Disp)
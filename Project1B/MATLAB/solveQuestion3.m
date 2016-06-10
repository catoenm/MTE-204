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

option = 4;
for i = 1:length(loadCurveFiles)
    explicitResults(i).option = option;
    timeSteps{i} = loadCurveFiles(i).name(8:end-4);
    [explicitResults(i).uGlobal, explicitResults(i).fGlobal, explicitResults(i).UComplete] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    explicitNode2Disp(i, :) = explicitResults(i).UComplete(2, :);
end

velocityW1 = diff(explicitNode2Disp(1, :), 1)/0.000001;
velocityW2 = diff(explicitNode2Disp(2, :), 1)/0.000001;
velocityW3 = diff(explicitNode2Disp(3, :), 1)/0.000001;

accelerationW1 = diff(explicitNode2Disp(1, :), 2)/0.000001;
accelerationW2 = diff(explicitNode2Disp(2, :), 2)/0.000001;
accelerationW3 = diff(explicitNode2Disp(3, :), 2)/0.000001;

figure;
title('Question 3C: Velocity of Node 2 after 500ms');
plot(velocityW1);
plot(velocityW2);
plot(velocityW3);

figure;
title('Question 3C: Velocity of Node 2 after 500ms');
plot(velocityW1);
plot(velocityW2);
plot(velocityW3);

figure;
title('Question 3C: Acceleration of Node 2 after 500ms');
plot(accelerationW1);
plot(accelerationW2);
plot(accelerationW3);




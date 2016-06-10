clc
clear all
close all

symbolSpec = '^*o.';
colorSpec = 'rbmk';

loadCurves = 'Input_Files/Question3/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question3/props_3.txt';
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

option = 2;
for i = 1:length(loadCurveFiles)
    explicitResults(i).option = option;
    timeSteps{i} = loadCurveFiles(i).name(9:end-4);
    [explicitResults(i).uGlobal, explicitResults(i).fGlobal, explicitResults(i).UComplete] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    explicitNode2Disp(i, :) = explicitResults(i).UComplete(4, :);
end

velocityW1 = diff(explicitNode2Disp(1, :), 1)/0.01;
velocityW2 = diff(explicitNode2Disp(2, :), 1)/0.01;
velocityW3 = diff(explicitNode2Disp(3, :), 1)/0.01;

accelerationW1 = diff(explicitNode2Disp(1, :), 2)/0.0001;
accelerationW2 = diff(explicitNode2Disp(2, :), 2)/0.0001;
accelerationW3 = diff(explicitNode2Disp(3, :), 2)/0.0001;

figure;
hold on
plot(explicitNode2Disp(3, :), 'g', 'DisplayName', strcat('\omega = ',timeSteps{3}));
plot(explicitNode2Disp(2, :), 'r', 'DisplayName', strcat('\omega = ',timeSteps{2}));
plot(explicitNode2Disp(1, :), 'b', 'DisplayName', strcat('\omega = ',timeSteps{1}));
title('Question 3C: Displacement of Node 2 after 500ms');
legend('show');

figure;
hold on
plot(velocityW3, 'g', 'DisplayName', strcat('\omega = ',timeSteps{3}));
plot(velocityW2, 'r', 'DisplayName', strcat('\omega = ',timeSteps{2}));
plot(velocityW1, 'b', 'DisplayName', strcat('\omega = ',timeSteps{1}));
title('Question 3C: Velocity of Node 2 after 500ms');
legend('show');

figure;
hold on
plot(accelerationW3, 'g', 'DisplayName', strcat('\omega = ',timeSteps{3}));
plot(accelerationW2, 'r', 'DisplayName', strcat('\omega = ',timeSteps{2}));
plot(accelerationW1, 'b', 'DisplayName', strcat('\omega = ',timeSteps{1}));
title('Question 3C: Acceleration of Node 2 after 500ms');
legend('show');



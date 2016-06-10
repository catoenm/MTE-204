clc
clear all
close all

symbolSpec = '^*o.';
colorSpec = 'rbmk';

loadCurves = 'Input_Files/Question2/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question2/props_2.txt';
nodes = 'Input_Files/Question2/nodes_2.txt';
sctr = 'Input_Files/Question2/sctr_2.txt';

% *************************************************************************
% Question 2B
% *************************************************************************

option = 2;

for i = 1:length(loadCurveFiles)
    results(i).option = option;
    results(i).timeStep = loadCurveFiles(i).name(8:end);
    [results(i).uGlobal, results(i).fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
end

bar(implicitNode2Disp,'b','DisplayName','Explicit Dynamics');
set(gca, 'XTick', 1:4, 'XTickLabel', timeSteps);
legend('show');
title('Question 2b: Displacement of Node 11 after 5 Seconds');
ylim([0 1]);
xlabel('\Delta t');
ylabel('Displacement (m)');

legend('show');
title('Question 2: ---');

% *************************************************************************
% Question 1C
% *************************************************************************

option = 4;

for i = 1:length(loadCurveFiles)
    results(i).option = option;
    results(i).timeStep = loadCurveFiles(i).name(8:end);
    [results(i).uGlobal, results(i).fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
end

bar(implicitNode2Disp,'b','DisplayName','Implicit Dynamics');
set(gca, 'XTick', 1:4, 'XTickLabel', timeSteps);
legend('show');
title('Question 2b: Displacement of Node 11 after 5 Seconds');
ylim([0 1]);
xlabel('\Delta t');
ylabel('Displacement (m)');

legend('show');
title('Question 2: ---');


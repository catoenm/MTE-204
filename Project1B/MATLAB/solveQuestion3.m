clc
clear all
close all

symbolSpec = '^*o.';
colorSpec = 'rbmk';

loadCurves = 'Input_Files/Question3/curves/';
fileType = '*.txt';
loadCurveFiles = dir(strcat(loadCurves,fileType));
props = 'Input_Files/Question1/props.txt';
nodes = 'Input_Files/Question1/nodes_3.txt';
sctr = 'Input_Files/Question1/sctr_3.txt';

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
    [explicitResults(1).uGlobal, explicitResults(i).fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    explicitNode2Disp(1,i) = explicitResults(1).uGlobal(2);
end

figure
hold on
bar(explicitNode2Disp, 'r','DisplayName','Explicit Dynamics');
set(gca, 'XTick', 1:4, 'XTickLabel', timeSteps);
legend('show');
title('Question 1a: Displacement of Node 2 after 5 Seconds');
ylim([0 1]);
xlabel('\Delta t');
ylabel('Displacement (m)');

% *************************************************************************
% Question 1b
% *************************************************************************

option = 2;

figure;
hold on;
for i = 1:length(loadCurveFiles)
    timeSteps{i} = loadCurveFiles(i).name(8:end-4);
    [implicitResults(1).uGlobal, implicitResults(i).fGlobal] = runSimulation(nodes, sctr, props, strcat(loadCurves, loadCurveFiles(i).name), option);
    implicitNode2Disp(1,i) = implicitResults(1).uGlobal(2);
end

bar(implicitNode2Disp,'b','DisplayName','Implicit Dynamics');
set(gca, 'XTick', 1:4, 'XTickLabel', timeSteps);
legend('show');
title('Question 1b: Displacement of Node 2 after 5 Seconds');
ylim([0 1]);
xlabel('\Delta t');
ylabel('Displacement (m)');

% *************************************************************************
% Question 1c
% *************************************************************************

t = 5;
k = 10;
m = 10;
c = 1;
F = 10;
omegaN = sqrt(k/m);
zeta = c/(2*m*omegaN);
omegaD = omegaN*sqrt(1-zeta^2);
theta = atan(zeta/sqrt(1-zeta^2));
uZero = 0;
uDotZero = 0;
firstTerm = F/k;
secondTerm = F/(k*sqrt(1-zeta^2))*exp(-zeta*omegaN*t)*cos(omegaD*t - theta);
thirdTerm = ((uDotZero + zeta*omegaN*uZero)/omegaD)*sin(omegaD*t);
fourthTerm = uZero*cos(omegaD*t);
fifthTerm = exp(-zeta*omegaN*t)*(thirdTerm + fourthTerm);
result = firstTerm - secondTerm + fifthTerm;

% *************************************************************************
% Question 1d
% *************************************************************************

disp('Question 1D:')
disp('Global Forces (Implicit)')

for i = 1:length(loadCurveFiles)
    disp(timeSteps{i})
    disp(implicitResults(i).fGlobal)
end


disp('Global Forces (Explicit)')

for i = 1:length(loadCurveFiles)
    disp(timeSteps{i})
    disp(explicitResults(i).fGlobal)
end
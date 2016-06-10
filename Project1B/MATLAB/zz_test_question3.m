clc
clear all

props = 'Input_Files/Question3/props_3.txt';
nodes = 'Input_Files/Question3/nodes_3.txt';
sctr = 'Input_Files/Question3/sctr_3.txt';
load_curve = 'Input_Files/Question3/curves/q3_freq_1.0.txt';

[uGlobal, fGlobal, uComplete] = runSimulation(nodes, sctr, props, load_curve, 4);

nodesMatrix = load(nodes);
sctrMatrix = load(sctr);

for i = 1:5000:length(uComplete)
    t = i*0.01;
    postprocesser(nodesMatrix(:,1),nodesMatrix(:,2),sctrMatrix',uComplete(:,i))   
    plottitle = sprintf('Deformation of Structure at Time %f ms' ,t);
    title(plottitle)
    plottitle = sprintf('Deformation of Structure at inc %d',i);
    saveas(2,plottitle,'png');
    display(t);
    clf(2);   
end
clc;
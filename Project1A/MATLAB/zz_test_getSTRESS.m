clc
clear all

NODES = load('nodes2.txt');
SCTR = load('sctr2.txt');
UGLOBAL = ones(size(NODES,1)*2,1).*100;
UGLOBAL(1) = 0;
UGLOBAL(2) = 0;
YOUNG = ones(size(SCTR,1),1);

getSTRESS(SCTR,NODES,YOUNG,2,UGLOBAL);

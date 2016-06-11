function [NODES,SCTR,PROPS,LOAD_CURVE] = open_files(nodes,sctr,props,loadCurve)

% % % This function receives a list of five file names, reads the data, and
% % % returns them as arrays

NODES = load(nodes);
SCTR = load(sctr);
PROPS = load(props);
LOAD_CURVE = load(loadCurve);



return
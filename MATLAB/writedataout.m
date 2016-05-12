function writedataout(filename,NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS)
% % % This function outputs a file a containing all the information
% % % required as presented in the DEMO submission file.

% % % This function also determines what stress state a member is under.
fid0 = fopen('./name_id.txt','w');
nFile = textscan(fid0, '%s','delimiter', '\n');
fclose(fid0);
fid1 = fopen('./headings.txt','w');
hFile = textcan(fid1, '%s','delimiter', '\n');
fclose(fid1);

if (exist('./' + filename + '.txt','file') ~= 0)
    delete('./' + filename + '.txt');
end

fid2 = fopen('./' + filename + '.txt','w');
fprintf(fid1, '%s\n', nFile);
fprintf(fid1, '\n%s\n%s\n\%s\n\%s\n',hFile{1}, hFile{2}, hFile{3}, hFile{4});

sizeFR = size(1,FGLOBAL)
sizeFC = size(FGLOBAL,1)

for ii = 1:sizeFR
    fprintf(fid2,'%10.5f\n',X(ii)); %file id, %f the location of the value
    if (mod(ii,2)==0)
        fprintf(fid2,'\n');
    else
        fprintf(fid2,',');
end
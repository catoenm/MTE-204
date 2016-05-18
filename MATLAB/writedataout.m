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

k = strfind(filename,'1a');
fprintf(fid1, '\n%s\n', hFile{1});
if(isempty(k))
    fprintf(fid1, '%s\n', hFile{3});
else
    fprintf(fid1, '%s\n', hFile{2});
end

fprintf(fid1, '\%s\n\%s\n', hFile{4}, hFile{5});

nRows = size(FGLOBAL, 1); 
%nRows should be same for following matrices: 
%FGLOBAL, UGLOBAL, NODES
for ii = 1:nRows
    fprintf(fid2,'F%c = %10.5f',32+ii,FGLOBAL(ii)); %file id, %f the location of the value
    %assumes less than 26 values
    if (mod(ii,2)==0)
        fprintf(fid2,'\n');
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid1, '\n%s\n', hFile{6});

for ii = 1:nRows
    fprintf(fid2,'U');
    %assumes at most 3DOF
    if DOF == 1
        fprintf(fid2,'%d',ii);   
    elseif DOF == 2
        if mod(ii,2)== 0
            fprintf(fid2,'%dy',ii); 
        else
        	fprintf(fid2,'%dx',ii);   
        end   
    else
        if mod(ii,3)== 0
            fprintf(fid2,'%dz',ii); 
        elseif mod(ii,3)== 2
        	fprintf(fid2,'%dy',ii); 
        else
            fprintf(fid2,'%dx',ii); 
        end
    end
    
    fprintf(fid2,'%10.5f',UGLOBAL(ii)); %file id, %f the location of the value

    if (mod(ii,2)==0)
        fprintf(fid2,'\n');
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid1, '\n%s\n', hFile{7});


for ii = 1:nRows
    fprintf(fid2,'F');
    %assumes at most 3DOF
    if DOF == 1
        fprintf(fid2,'%d',ii);   
    elseif DOF == 2
        if mod(ii,2)== 0
            fprintf(fid2,'%dy',ii); 
        else
        	fprintf(fid2,'%dx',ii);   
        end   
    else
        if mod(ii,3)== 0
            fprintf(fid2,'%dz',ii); 
        elseif mod(ii,3)== 2
        	fprintf(fid2,'%dy',ii); 
        else
            fprintf(fid2,'%dx',ii); 
        end
    end
    
    fprintf(fid2,'%10.5f',NODES(ii)); %file id, %f the location of the value
    
    if (mod(ii,2)== 0)
        fprintf(fid2,'\n');
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid2, '\n%s\n%s\n%s\n', hFile{7}, hFile{8}, hFile{9});

nCol = sizeof(SCTR,2);
for ii = 1:nRows
    fprintf(fid2,'%d, ',ii);
    for jj = 1:nCol
        fprintf(fid2,'%d, ',ii,SCTR(ii,jj));
    end
    fprintf(fid2,'%f',abs(STRESS(ii)));
    
    if STRESS(ii) < 0 
        fprintf(fid2,'[Compression]');
    else
        fprintf(fid2,'[Tension]');  
    end
end











    
function writedataout(filename,NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS)
% % % This function outputs a file a containing all the information
% % % required as presented in the DEMO submission file.

% % % This function also determines what stress state a member is under.
fid0 = fopen('./name_id.txt','w'); %opens name file
nFile = textscan(fid0, '%s','delimiter', '\n'); % reads in name file delimiting breaks
fclose(fid0); % close name file
fid1 = fopen('./headings.txt','w'); % opens file with premade output lines
hFile = textscan(fid1, '%s','delimiter', '\n'); % reads in heading file delimiting breaks
fclose(fid1); % close heading file

if exist('./' + filename + '.txt','file') ~= 0 %checks if file with filename currently exists
    delete('./' + filename + '.txt'); %delete file if found
end

fid2 = fopen('./' + filename + '.txt','w'); %open file with filename
fprintf(fid2, '%s\n', nFile); %writes all names into file

k = strfind(filename,'1a'); %checks if filename contains substring 1a
fprintf(fid1, '\n%s\n', hFile{1}); %writes 1a heading
if(isempty(k)) %if cannot find 1a substring in filename
    fprintf(fid1, '%s\n', hFile{3}); %writes 1b heading
else
    fprintf(fid1, '%s\n', hFile{2}); %writes 1a heading
end

fprintf(fid1, '\%s\n\%s\n', hFile{4}, hFile{5}); %print other submission headings

nRows = size(FGLOBAL, 1); %gets number of elements

%nRows should be same for following matrices: 
%FGLOBAL, UGLOBAL, NODES
for ii = 1:nRows
    fprintf(fid2,'F%c = %10.5f',31+ii,FGLOBAL(ii)); %file id, %f the location of the value
    %assumes less than 26 values
    if mod(ii,2)==0
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
    elseif DOF == 2 %if DOF = 2
        if mod(ii,2)== 0
            fprintf(fid2,'%dy',ii); 
        else
        	fprintf(fid2,'%dx',ii);   
        end   
    else
        if mod(ii,3)== 0 %then DOF = 3
            fprintf(fid2,'%dz',ii); 
        elseif mod(ii,3)== 2
        	fprintf(fid2,'%dy',ii); 
        else
            fprintf(fid2,'%dx',ii); 
        end
    end
    
    fprintf(fid2,' = %10.5f',UGLOBAL(ii)); %file id, %f the location of the value

    if mod(ii,2)==0
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
    
    fprintf(fid2,' = %10.5f',NODES(ii)); %file id, %f the location of the value
    
    if mod(ii,2)== 0
        fprintf(fid2,'\n');
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid2, '\n%s\n%s\n%s\n', hFile{8}, hFile{9}, hFile{10});

nCol = size(SCTR,2);
for ii = 1:nRows 
    fprintf(fid2,'%d, ',ii); %prints out element number
    for jj = 1:nCol
        fprintf(fid2,'%d, ',ii,SCTR(ii,jj)); %prints out first node, then second node
    end
    fprintf(fid2,'%f ',abs(STRESS(ii))); %print out absolute stress value
    
    if STRESS(ii) < 0 %if stress is negative, then stress is compressive
        fprintf(fid2,'[Compression]');
    else
        fprintf(fid2,'[Tension]');  
    end
end    
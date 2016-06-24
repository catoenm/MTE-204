function writedataout(filename,NODES,SCTR,DOF,UGLOBAL,FGLOBAL,STRESS,FORCES, BUCKLINGFORCE)
% % % This function outputs a file a containing all the information
% % % required as presented in the DEMO submission file.

% % % This function also determines what stress state a member is under.
fid0 = fopen('./name_id.txt','r'); %opens name file
nFile = textscan(fid0, '%s','delimiter', '\n'); % reads in name file delimiting breaks
fclose(fid0); % close name file

fid1 = fopen('./headings.txt','r'); % opens file with premade output lines
hFile = textscan(fid1, '%s','delimiter', '\n'); % reads in heading file delimiting breaks
fclose(fid1); % close heading file

if exist(strcat('./', filename),'file') ~= 0 %checks if file with filename currently exists
    delete(strcat('./', filename)); %delete file if found
end

fid2 = fopen(strcat('./', filename),'w'); %open file with filename

for jj = 1:8
    fprintf(fid2, '%s\n', char(nFile{1,1}(jj,1))); %writes all names into file
end

k = strfind(filename,'1a'); %checks if filename contains substring 1a
fprintf(fid2, '\n%s\n', char(hFile{1,1}(1,1))); %writes 1a heading

if(~isempty(k)) %if cannot find 1a substring in filename
    fprintf(fid2, '%s\n', char(hFile{1,1}(2,1))); %writes 1b heading
else
    fprintf(fid2, '%s\n', char(hFile{1,1}(3,1))); %writes 1a heading
end

fprintf(fid2, '%s\n%s\n', char(hFile{1,1}(4,1)), char(hFile{1,1}(5,1))); %print other submission headings

num_rows = size(FGLOBAL, 1); %gets number of elements

%nRows should be same for following matrices: 
%FGLOBAL, UGLOBAL, NODES
%calculated from student numbers
fprintf(fid2,'FA = 2630.000000, ');
fprintf(fid2,'FB = 600.000000\n');
fprintf(fid2,'FC = 380.000000, ');
fprintf(fid2,'FD = 3550.000000\n');

fprintf(fid2, '\n%s\n', char(hFile{1,1}(6,1)));

count = 1;
for ii = 1:num_rows
    fprintf(fid2,'U');
    %assumes at most 3DOF
    if DOF == 1
        fprintf(fid2,'%d ',ii);   
    elseif DOF == 2 %if DOF = 2
        if mod(ii,DOF)== 0
            fprintf(fid2,'%dy ',count); 
        else
        	fprintf(fid2,'%dx ',count);   
        end   
    else
        if mod(ii,DOF)== 0 %then DOF = 3
            fprintf(fid2,'%fz ',ii); 
        elseif mod(ii,3)== 2
        	fprintf(fid2,'%fy ',ii); 
        else
            fprintf(fid2,'%fx ',ii); 
        end
    end
    
    fprintf(fid2,' = %10.5f',UGLOBAL(ii)); %file id, %f the location of the value

    if mod(ii,DOF)==0
        fprintf(fid2,'\n');
        count = count + 1;
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid2, '\n%s\n', char(hFile{1,1}(7,1)));

count = 1;
for ii = 1:num_rows
    fprintf(fid2,'F');
    %assumes at most 3DOF
    if DOF == 1
        fprintf(fid2,'%d',ii);   
    elseif DOF == 2
        if mod(ii,DOF)== 0
            fprintf(fid2,'%dy',count); 
        else
        	fprintf(fid2,'%dx',count);   
        end   
    else
        if mod(ii,DOF)== 0
            fprintf(fid2,'%dz',ii); 
        elseif mod(ii,3)== 2
        	fprintf(fid2,'%dy',ii); 
        else
            fprintf(fid2,'%dx',ii); 
        end
    end
    
    fprintf(fid2,' = %10.5f',FGLOBAL(ii)); %file id, %f the location of the value
    
    if mod(ii,DOF)== 0
        fprintf(fid2,'\n');
        count = count + 1;
    else
        fprintf(fid2,', ');
    end
end

fprintf(fid2, '\n%s\n%s\n%s\n', char(hFile{1,1}(8,1)), char(hFile{1,1}(9,1)), char(hFile{1,1}(10,1)));

num_rows = size(SCTR,1);
num_columns = size(SCTR,2);
for ii = 1:num_rows 
    fprintf(fid2,'%d, ',ii); %prints out element number
    for jj = 1:num_columns
        fprintf(fid2,'%d, ',SCTR(ii,jj)); %prints out first node, then second node
    end
    fprintf(fid2,'%f ',abs(STRESS(ii))); %print out absolute stress value
    
    if STRESS(ii) < 0 %if stress is negative, then stress is compressive
        fprintf(fid2,'[Compression]\n');
    else
        fprintf(fid2,'[Tension]\n');  
    end
end    

fprintf(fid2, '\n%s\n%s\n%s\n', char(hFile{1,1}(11,1)), char(hFile{1,1}(12,1)), char(hFile{1,1}(13,1)));

for ii = 1:num_rows 
    fprintf(fid2,'%d, ',ii); %prints out element number
    for jj = 1:num_columns
        fprintf(fid2,'%d, ',SCTR(ii,jj)); %prints out first node, then second node
    end
    fprintf(fid2,'%f ',abs(FORCES(ii))); %print out absolute stress value
    
    if FORCES(ii) < 0 %if stress is negative, then stress is compressive
        fprintf(fid2,'[Compression]\n');
    else
        fprintf(fid2,'[Tension]\n');  
    end
end

fprintf(fid2, '\n%s\n%s\n%s\n', char(hFile{1,1}(14,1)), char(hFile{1,1}(15,1)), char(hFile{1,1}(16,1)));

for ii = 1:num_rows 
    fprintf(fid2,'%d, ',ii); %prints out element number
    for jj = 1:num_columns
        fprintf(fid2,'%d, ',SCTR(ii,jj)); %prints out first node, then second node
    end
    fprintf(fid2,'%f ',abs(BUCKLINGFORCE(ii, 1))); %print out absolute stress value
    
    if FORCES(ii) < 0 %if stress is negative, then stress is compressive
        if abs(FORCES(ii)) > BUCKLINGFORCE(ii, 1)
            fprintf(fid2,'[Buckling Failure]\n');
        else
            fprintf(fid2,'[No Buckling Failure]\n');
        end
    else
        fprintf(fid2,'[N/A - Tension]\n');  
    end
end

fprintf(fid2, '\n%s\n%s\n%s\n', char(hFile{1,1}(17,1)), char(hFile{1,1}(18,1)), char(hFile{1,1}(19,1)));

for ii = 1:num_rows 
    fprintf(fid2,'%d, ',ii); %prints out element number
    for jj = 1:num_columns
        fprintf(fid2,'%d, ',SCTR(ii,jj)); %prints out first node, then second node
    end
    fprintf(fid2,'%f ',abs(BUCKLINGFORCE(ii, 2))); %print out absolute stress value
    
    if FORCES(ii) < 0 %if stress is negative, then stress is compressive
        if abs(FORCES(ii)) > BUCKLINGFORCE(ii, 2)
            fprintf(fid2,'[Buckling Failure]\n');
        else
            fprintf(fid2,'[No Buckling Failure]\n');
        end
    else
        fprintf(fid2,'[N/A - Tension]\n');  
    end
end

fclose(fid2);

end
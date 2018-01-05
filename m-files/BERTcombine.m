function BERTcombine(file1,file2,outfile,otherelecs,twoorthreed,errgiven)
% BERTcombine(file1,file2,outfile,otherelecs,twoorthreed,errgiven)
%
% Combines the ohm file file1 and the ohm file file2 to a 
% combined ohm file
%
% INPUT:
%
% file1         name of first file (don't forget the .ohm part)
% file2         name of second file (don't forget the .ohm part)
% outfile       name for the optput file (don't forget the .ohm part)
% otherelecs    are the two files measured with the different electrodes?
%               1 for yes, 0 for no (same electrodes used)
% twoorthreed   0 for 2D data points (x z), 1 for 3D (x y z)
% errgiven      does the ohm file contain the errors values? 1 for yes
%
% Last modified by aplattner-at-ethz.ch, 11/18/2016


if length(nargin)<6
    errgiven=0;
end
fid1=fopen(file1);
fid2=fopen(file2);
fidout=fopen(outfile,'w');

% First line gives number of elecs

line1=fgetl(fid1);
lnf1=sscanf(line1,'%d%s');
line2=fgetl(fid2);
lnf2=sscanf(line2,'%d%s');
nelecs1=lnf1(1);
nelecs2=lnf2(1);

% Depending on if we have the same electrodes or not, define 
% the total number of electrodes
if otherelecs
    nelecs=nelecs1+nelecs2;
else
    nelecs=nelecs2;
end
fprintf(fidout,'%d#%s\n',nelecs,' Number of electrodes');

% The next line just gives coordinates
fgetl(fid1);
fgetl(fid2);
if twoorthreed
    fprintf(fidout,'%s\n','# x y z');
else
    fprintf(fidout,'%s\n','# x z');
end

% Now write out the electrode positions
if twoorthreed
    for i=1:nelecs1
        line1=fgetl(fid1);
        lnf1=sscanf(line1,'%f\t%f\t%f');
        fprintf(fidout,'%f\t%f\t%f\n',lnf1(1),lnf1(2),lnf1(3));        
    end
else
    for i=1:nelecs1
        line1=fgetl(fid1);
        lnf1=sscanf(line1,'%f\t%f');
        fprintf(fidout,'%f\t%f\n',lnf1(1),lnf1(2));   
    end
end

% Depending on if we use different electrodes for the second dataset, we
% need to now put these into the file
% Otherwise we just need to skip through those lines
if otherelecs
    if twoorthreed
        for i=1:nelecs2
            line2=fgetl(fid2);
            lnf2=sscanf(line2,'%f\t%f\%f');
            fprintf(fidout,'%f\t%f\t%f\n',lnf2(1),lnf2(2),lnf2(3));        
        end
    else
        for i=1:nelecs2
            line2=fgetl(fid2);
            lnf2=sscanf(line2,'%f\t%f');
            fprintf(fidout,'%f\t%f\n',lnf2(1),lnf2(2));   
        end
    end
else
    for i=1:nelecs2
        fgetl(fid2);
    end
end

% Now come the electrode combinations
% How many?
line1=fgetl(fid1);
lnf1=sscanf(line1,'%d# %s %s %s');

line2=fgetl(fid2);
lnf2=sscanf(line2,'%d# %s %s %s');
ndata1=lnf1(1);
ndata2=lnf2(1);
fprintf(fidout,'%d#%s\n',ndata1+ndata2,' Number of data');

% Skip the next line
fgetl(fid1);
fgetl(fid2);
fprintf(fidout,'#a\tb\tm\tn\tR\n');

% If we use the same electrodes then we don't need to change
% the electrode number in the second file.
% If we use different electrodes, we have to adapt the electrode number
% from the second file
if otherelecs
    addelecs=nelecs1;
else
    addelecs=0;
end

% Now read and write the data points
if errgiven
    % from the first file
    for i=1:ndata1        
        line1=fgetl(fid1);
        lnf1=sscanf(line1,'%d\t%d\t%d\t%d\t%f\t%f');
        fprintf(fidout,'%d\t%d\t%d\t%d\t%f\%f\n',...
            lnf1(1),lnf1(2),lnf1(3),lnf1(4),lnf1(5),lnf1(6));
    end
    % from the second file
    for i=1:ndata2
        line2=fgetl(fid2);
        lnf2=sscanf(line2,'%d\t%d\t%d\t%d\t%f\t%f');
        fprintf(fidout,'%d\t%d\t%d\t%d\t%f\t%f\n',...
            lnf2(1)+addelecs,lnf2(2)+addelecs,...
            lnf2(3)+addelecs,lnf2(4)+addelecs,lnf2(5),lnf2(6));
    end
else
     % from the first file
    for i=1:ndata1
        line1=fgetl(fid1);
        lnf1=sscanf(line1,'%d\t%d\t%d\t%d\t%f');
        fprintf(fidout,'%d\t%d\t%d\t%d\t%f\n',...
            lnf1(1),lnf1(2),lnf1(3),lnf1(4),lnf1(5));
    end
    % from the second file
    for i=1:ndata2
        line2=fgetl(fid2);
        lnf2=sscanf(line2,'%d\t%d\t%d\t%d\t%f');
        fprintf(fidout,'%d\t%d\t%d\t%d\t%f\n',...
            lnf2(1)+addelecs,lnf2(2)+addelecs,...
            lnf2(3)+addelecs,lnf2(4)+addelecs,lnf2(5));
    end
    
end
    
% Closing all the files
fclose(fid1);
fclose(fid2);
fclose(fidout);

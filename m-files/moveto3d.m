function moveto3d(vtkfilein,vtkfileout,firste3d,firste2d,laste3d,laste2d)
% moveto3d(vtkfilein,vtkfileout,firste3d,firste2d,laste3d,laste2d)
%
% Function to move a vtk result obtained from running BERT for a 2D
% profile, to its actual 3D position such that it can be displayed in
% paraview with other 2D lines.
%
% INPUT:
%
% vtkfilein     name (and path) of vtk file that was produced by BERT
% vtkfileout    name (and path) for vtk file you want to create
% firste3d      [x,y,z] position of first electrode in 3D
% firste2d      [x,y,z] position of first electrode in BERT calculations 
%               (usually [0,0,z1]), where z1 is the elevation of the
%               first electrode.
% laste3d       [x,y,z] position of last electrode in 3D
% laste2d       [x,y,z] position of last electrode in BERT calculations
%               (usually [xlast,0,zlast])
%
% Last modified by plattner-at-alumni.ethz.ch, 2/20/2017


% shift all points such that both first electrodes are at 0/0/0
end3d=laste3d(1:2)-firste3d(1:2);
end2d=laste2d(1:2)-firste2d(1:2);
% Make them all unit length
end3d=end3d/norm(end3d);
end2d=end2d/norm(end2d);



% Calculate rotation angle
midpoint=(end3d+end2d)/2;
d=norm(midpoint-end2d);
angle=2*asin(d);
% if the 3d direction has positive y, then the rotation is
% counterclockwise. Otherwise it is clockwise
angle=angle*sign(end2d(1))*sign(end3d(2));

% Assemble rotation matrix
M=[cos(angle),-sin(angle);sin(angle),cos(angle)];


% Open the files
fin=fopen(vtkfilein,'r');
fout=fopen(vtkfileout,'w');

% Read and write first 4 lines
for i=1:4
    line=fgetl(fin);
    fprintf(fout,[line '\n']);
end

% 5th line contains number of points
line=fgetl(fin);
npoints=sscanf(line,'POINTS %d double');
fprintf(fout,'POINTS %d double\n',npoints);

for i=1:npoints
    line=fgetl(fin);
    readpoint=sscanf(line,'%f %f %f');
    % The vtk output of BERT has the z and y coordinates switched
    rotpoint=M*[readpoint(1);readpoint(3)];
    % We also need to shift the points with respect to the starting
    % electrode
    newpoint=[firste3d(1),firste3d(2),0]+[rotpoint(1),rotpoint(2),readpoint(2)];        
    fprintf(fout,'%f %f %f\n',newpoint(1),newpoint(2),newpoint(3));        
end

while ~feof(fin)
    line=fgetl(fin);
    fprintf(fout,[line '\n']);
end

fclose(fin);
fclose(fout);







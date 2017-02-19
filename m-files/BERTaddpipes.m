function intf=BERTaddpipes(center,radius,fname,res)
% BERTaddpipes(centers,radii,fname)
%
% Adds a circular boundary interface that BERT can read. Circle is
% described by center [x,z] position and radius
%
% INPUT:
%
% centers   n x 2 matrix [x,z] of centers of circles usually in meters
% radii     vector of radii of circle (same units as x,z)
% fname     name for the interface file
% res       how many points should the circle contain (at least 4)
%
% OUTPUT:
%
% intf      points on the circle that can be plotted by
%           plot(intf(:,1),intf(:,2))
%
% Last modified by plattner-at-alumni.ethz.ch, 9/30/2016

fid=fo

for ncirc=1:length(radii)

alpha=linspace(0,2*pi,res);
intf=zeros(length(alpha),2);
intf(:,1)=radius*sin(alpha)+center(1);
intf(:,2)=radius*cos(alpha)+center(2);

save(fname,'intf','-ascii')




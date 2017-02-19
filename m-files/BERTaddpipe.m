function intf=BERTaddpipe(center,radius,fname,res)
% BERTaddpipe(center,radius,fname)
%
% Adds a circular boundary interface that BERT can read. Circle is
% described by center [x,z] position and radius
%
% INPUT:
%
% center    [x,z] of center of circle usually in meters
% radius    radius of circle (same units as x,z)
% fname     name for the interface file
% res       how many points should the circle contain (at least 4)
%
% OUTPUT:
%
% intf      points on the circle that can be plotted by
%           plot(intf(:,1),intf(:,2))
%
% Last modified by plattner-at-alumni.ethz.ch, 9/30/2016

% Make circle
% Make gap at bottom
alpha=linspace(-pi,pi,res);
intf=zeros(length(alpha),2);
intf(:,1)=radius*sin(alpha+pi/res)+center(1);
intf(:,2)=radius*cos(alpha+pi/res)+center(2);

intf=intf(1:end-1,:);

save(fname,'intf','-ascii')




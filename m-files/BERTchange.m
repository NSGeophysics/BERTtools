function BERTchange(indir1,indir2,outdir,op)
% BERTchange(indir1,indir2,outdir,op)
% 
% Calculates the difference or ratio between BERT inversion results 
% calculated on the same grid 
% 
% INPUT:
%  
% indir1    directory of first solution
% indir2    directory of second solution
% outdir    directory to store resulting difference or ratio in
%
% Last modified by plattner-at-alumni.ethz.ch, 9/28/2016

% Make outdir and copy everything necessary there

mkdir(outdir)

system(sprintf('cp -r %s/mesh/ %s/mesh/',indir1,outdir));
system(sprintf('cp %s/coverage.vector %s/coverage.vector',indir1,outdir));

res1=load(sprintf('%s/resistivity.vector',indir1));
res2=load(sprintf('%s/resistivity.vector',indir2));

switch op
    case 1
        res=res2-res1;
    case 2
        res=res2./res1;
    case 3
        res=(res2-res1)./res2;
    case 4
        res=res2-res1;
        res(res>0)=0;
end

save(sprintf('%s/resistivity.vector',outdir),'res','-ascii')



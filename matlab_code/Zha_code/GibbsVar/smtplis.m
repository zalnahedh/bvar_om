function [Avhx,hAvhx,cJump] = smtplis(Avhx,hAvhx,tdf,cJump,scf,...
                       H_sr,nfp,Sbd,fss,nvar,a0indx)
%
%      Straight Metropolis Algorithm for identified VARs
%
% Avhx: previous draw of parameter x in 1st (kept) sequence
% hAvhx: lh value of previous draw in 1st (kept) sequence
% tdf: degrees of freedom of the jump t-distribution
% cJump: old count for times of jumping
% scf: scale down factor for stand. dev. -- square root of covariance matrix H
% H_sr: square root of covariance matrix H in approximate density
% nfp: number of free parameters
% Sbd: S in block diagonal covariance matrix in asymmetric prior case
% fss: effective sample size, including # of dummy observations
% nvar: number of variables
% a0indx: index of locations of free elements in A0
%--------------
% Avhx: new draw of parameter x in 1st (kept) sequence
% hAvhx: lh value of new draw in 1st (kept) sequence
% cJump: new count for times of jumping
%
% December 1998 by Tao Zha


%** draw free elements Avh in A0 and hyperparameters from t-dist
Avhz1 = scf*H_sr*randn(nfp,1);     % normal draws
csq=randn(tdf,1);
csq=sum(csq .* csq);
Avhz = Avhz1/sqrt(csq/tdf);

Avhy = Avhx + Avhz;      % random walk chain -- Metropolis
% ** actual density, having taken log
hAvhy = a0asfun(Avhy,Sbd,fss,nvar,a0indx);
hAvhy = -hAvhy;      % converted to logLH

mphxy = exp(hAvhy-hAvhx);

%** draw u from uniform(0,1)
u = rand(1);
Jump = min([mphxy 1]);
if u <= Jump
   Avhx = Avhy;
   hAvhx = hAvhy;
   cJump = cJump+1;
end

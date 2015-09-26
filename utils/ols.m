function [cope,varcope,tstat,p]=ols(data,des,tc)
% [COPE,VARCOPE,TSTAT,P]=OLS(DATA,DES,TC)
% DATA IS T x V
% DES IS T x EV (design matrix, should include column of ones)
% TC IS NCONTRASTS x EV  (contrast matrix, optional)
%
% V = number of dependent variables, should be 1 usually
% T = timepoints/trials
% EV = number of regressors
% 
% Output is all NCONSTRASTS x 1
% cope = the betas of each requested contrast
% varcope = According to Laurence: variance on the contrast estimate. Take
% squart root to get standard deviation, divide by datapoints to get SEM,
% etc. 
% tstat = t-statistic for each contrast
% p = (1-tcdf(abs(tstat),size(data,1))).*2 two sides p-value (added by PS)
% 
% TB 2004, commented PS 2011

% if no contrasts given, assume output is beta for each predictor
if ~exist('tc','var')
    tc = eye(size(des,2));
end

if(size(data,1)~=size(des,1))
  error('OLS::DATA and DES have different number of time points');
elseif(size(des,2)~=size(tc,2))
  error('OLS:: DES and EV have different number of evs')
end


pdes=pinv(des); %pseudo inverse of DES, dimension EV x T. des * pdes * des = des
prevar=diag(tc*pdes*pdes'*tc'); %inside brackets yields NCONTRASTS x NCONTRASTS. Diagonal takes the main diagonal of the matrix, so prevar is a column vector
R=eye(size(des,1))-des*pdes; % identity matrix (zeros with ones on main diagonal) of T x T. Subtracted from this is the T x T matrix: design_matrix * pseudoinverse of design matrix. Not sure what this yields
tR=trace(R); %adds up the main diagonal of R. What is R?
pe=pdes*data; % Betas most likely? pseudo-inverse, which is EV x T, multiplied by the data T x V. Yields EV x V matrix (number of regressors times number of dependent variables, normally 1. So, one value per regressor, but not sure what it means)
cope=tc*pe; %cope is contrast matrix times the one value per regressor, dimension: NCONTRASTS * V matrix, i.e. one value per contrast. This is probably labda (contrast vectors)*beta matrix. 
if(nargout>1) %if more is asked from the function, calculate some extra values
  res=data-des*pe; %residuals, calculated by data - (design matrix * betas)
  sigsq=sum(res.*res/tR); %sum of squared residuals, divided by some value
  varcope=prevar*sigsq; %something like: one value per contrast multiplied by the sum of squares. Apparently, variance of the particular contrast
  if(nargout>2)
    tstat=cope./sqrt(varcope); %tstat for each contrast: contrast divided by standard deviation of the contrast
    if nargout>3
        p = (1-tcdf(abs(tstat),size(data,1))).*2;
    end
  end
end
%**************************************************************************
%
%   Winner takes all mask.
%   1. Average all of the smwc files in each class (GM, WM, CSF)
%   2. Whichever class has the highest probability & has a mean probability
%      > 20% gets the voxel
%
%   MFC 01.02.2013
%   Some comments added by Peter S
%**************************************************************************

[GMfn sts] = spm_select([1 Inf], 'nii', 'Select gray matter', [], pwd, '^smwc1.*_MT');
if ~sts; return; end
numSubjs = size(GMfn, 1);
[WMfn sts] = spm_select(numSubjs, 'nii', 'Select white matter', [], pwd, '^smwc2.*_MT');
if ~sts; return; end
[CSFfn sts] = spm_select(numSubjs, 'nii', 'Select CSF', [], pwd, 'smwc3.*_MT');
if ~sts; return; end

% create nifti object
mask = nifti(GMfn(1,:));
pn = fileparts(GMfn(1,:));

GMMask = zeros(mask.dat.dim);
WMMask = zeros(mask.dat.dim);
summedProbs = zeros([mask.dat.dim, 3]);

for subj = 1 : numSubjs;
    
    GM = nifti(GMfn(subj, :));
    WM = nifti(WMfn(subj, :));
    CSF = nifti(CSFfn(subj, :));
    
    summedProbs(:,:,:,1) = summedProbs(:,:,:,1) + GM.dat(:,:,:);
    summedProbs(:,:,:,2) = summedProbs(:,:,:,2) + WM.dat(:,:,:);
    summedProbs(:,:,:,3) = summedProbs(:,:,:,3) + CSF.dat(:,:,:);
    
end
%finds the maximum for each voxel over the 3 modalities, and the index
%indicates which of the three maps had the max
[maxMap maxInd] = max(summedProbs, [], 4);

% Include in a particular mask if it has the highest group-wise probability
% and the mean probability is > 20%
GMMask(maxInd == 1 & summedProbs(:,:,:,1)/numSubjs > 0.2) = 1;
WMMask(maxInd == 2 & summedProbs(:,:,:,2)/numSubjs > 0.2) = 1;

% Write out:
mask.dat.fname = [pn filesep 'WinnerTakesAllMask_GM.nii'];
mask.dat(:,:,:) = GMMask;
create(mask);

mask.dat.fname = [pn filesep 'WinnerTakesAllMask_WM.nii'];
mask.dat(:,:,:) = WMMask;
create(mask);

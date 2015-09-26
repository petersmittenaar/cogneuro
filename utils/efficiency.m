function eff = efficiency(X,c)
%EFFICIENCY Calculates efficiency for convolved design matrix X 
% for contrasts c.
% c can be multiple contrasts (1 per row).
% 2013 Peter Smittenaar, completely based on Kay Brodersen's MSc thesis

assert(size(c,2) == size(X,2),'contrast vector should have as many columns as design matrix');
assert(~any(sum(c,2)),'contrasts should add up to zero; check your contrasts');
% Compute efficiency
for iContrast = 1:size(c,1)
    eff(iContrast,1) = 1 / trace(c(iContrast,:) * inv(X'*X) * c(iContrast,:)');
end
end


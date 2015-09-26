function cosangle = cosangle(a)
% calculates the angle between two vectors as done by SPM for its
% orthogonality assessment of the design matrix. input is a matrix and
% output is angle between all columns, just as corrcoef would output.
%                           a'*b
%                 ------------------------
%                 sqrt(sum(a.^2)*sum(b.^2)
% 
% The angle corresponds to the correlation (if the data has been
% de-meaned). The square of the angle corresponds to r^2.
% Peter Smittenaar, 2013

nColumns = size(a,2);
cosangle = nan(nColumns);
% match all columns with all other columns (redundant but easy)
for iColumn1 = 1:nColumns
    for iColumn2 = 1:nColumns
        cosangle(iColumn1,iColumn2) = (a(:,iColumn1)'*a(:,iColumn2))/sqrt(sum(a(:,iColumn1).^2)*sum(a(:,iColumn2).^2));
    end
end
end


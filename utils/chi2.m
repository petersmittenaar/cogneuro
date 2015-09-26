function [chistat, p] = chi2(selective,total)
% Calculates probability based on a 2 x 2 contingency chi2 statistic
% output = chi2(selective,total)

%example
%3 diff DVs and want to calculate whether DV encoding is significant
%DV selectivity [62 72 57], total recorded = 259
%[chistat,p]=chi2([62 72 57],[259 259 259])

%Peter addition: no need to give 'total' vector: computed from selective
if nargin == 1
    total(1:size(selective,2)) = sum(selective);
end

df = size(selective,2)-1;

if(isempty(find(selective==0, 1))==1 || isequal(selective,total)==1)
    for loop = 1:size(selective,1)
        observed = zeros(3,size(selective,2)+1);
        observed(1,1:size(selective,2)) = selective;
        observed(3,1:size(selective,2)) = total;
        observed(2,1:size(selective,2)) = total - selective;
        observed(:,size(selective,2)+1) = sum(observed,2);	
        
        expected = zeros(2,size(selective,2));
        for x = 1:size(selective,2)
            for y = 1:2
                expected(y,x) = observed(3,x)./observed(3,size(selective,2)+1)*observed(y,size(selective,2)+1);
            end
        end
        
        cell = zeros(2,size(selective,2));
        for x = 1:size(selective,2)
            for y=1:2
                if expected(y,x)~=0
                    cell(y,x) = ((abs(observed(y,x)-expected(y,x))-0.5)^2)/expected(y,x);
                else
                    cell(y,x) = NaN;
                end           
            end
        end
        chistat(loop) = sum(sum(cell));
        p(loop) = 1 - chi2cdf(chistat(loop),df);
    end
else
    chistat = NaN;
    p = NaN;
end

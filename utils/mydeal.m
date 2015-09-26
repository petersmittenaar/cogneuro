function mydeal(S);
% Hands variables to workspace
% by quentin huys, copied from his website.
A=fieldnames(S);
for k=1:length(A)
	assignin('caller',A{k},S.(A{k}));
end
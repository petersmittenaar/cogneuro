%%%%%%%%%%%%%%%%%
%%% Written by Quentin J. M. Huys, UCL, London 2011
%%% Reference:
%%% Guitart-Masip M, Quentin JM, Fuentemilla LL, Dayan P, Duzel E, Dolan RJ (2012)
%%% Go and no-go learning in reward and punishment: Interaction between affect and effect NeuroImage doi:10.1016/j.neuroimage.2012.04.024

clear all;
whichinf=8;

dt = '120403';

%load VectorsData

dosave = 1;
docomp = 1;
docheck = 0;
Nsample = 2000;

%for k=1:3; for j=1:2; a{k,j} = A{k,j}; r{k,j} = R{k,j};end;end
%R=r; A=a; clear a r; 

ff{1} = 'llba';
ff{2} = 'llbax';
ff{3} = 'llbaqx';
ff{4} = 'llbaxb';
ff{5} = 'llbaepxb';
ff{6} = 'll2baxb';
ff{7} = 'llba2epxb';
ff{8} = 'll2baepxb';


Npar=[2 3 4 4 5 5 6 6];
Np = Npar(whichinf);

for k=1:length(ff); ld{k} = [dt '-' ff{k}];end

Nsj=length(A);
Z.mu=zeros(Np,1);
Z.nui=eye(Np);

options=optimset('display','off','DerivativeCheck','on');
warning('off','optim:fminunc:SwitchingMethod')


emit=0;
while 1;emit=emit+1;sj=0;

	% E step......................................................
		for sj=1:length(A); 

			a=A{sj};
			r=R{sj};
            s=S{sj};

			ex=-1;tmp=0;tmp1=0;
			while ex<1;
				init=.1*randn(Np,1); 
				if docheck;
					checkgrad(ff{whichinf},init,.001, a, r,s, Z,1), 
					lkj
                else
					ex=1;
					str='[est,fval,ex,foo,foo, hess] = fminunc(@(x)';
					str=[str ff{whichinf}  '(x, a, r, s, Z,1),init,options);'];
					eval(str);
					if ex<0 ; tmp=tmp+1; fprintf('didn''t converge %i times exit status %i\r',tmp,ex); end
				end
			end

			exx(sj)=ex;
			E(:,sj)=est;													% Subjets' parameter estimate
			V(:,sj) = diag(inv(full(hess)));							% inverse of Hessian = variance
			PL(sj) = fval;													% posterior likelihood  (zeb- individual subject, with population prior)
			eval(['LL(sj)=' ff{whichinf} '(est,a,r,s,Z,0);']);	% likelihood   (zeb- maximum likelihood, without population, just data)

			fprintf('Emit=%i subject %i exit status=%i\r',emit,sj,exx(sj))
		end
	

	% M step using factorized posterior .................................
	mu = mean(E,2); 
	nu = sqrt(sum(E.^2 + V,2)/Nsj - mu .^2); 
	Z.mu = mu; Z.nui = inv(diag(nu));

	[mu nu]

	par(emit,:) = [sum(LL) sum(PL) mu' nu(:)'];						% save stuff
	et(emit,:,:) = E;
	if dosave; 
		eval(['save mat/' ld{whichinf} ' mu nu E V LL PL par et Z exx emit ld ff whichinf;']);
	end
	% check convergence ...........................................
	if emit>1;if sum(abs(par(emit,2:end)-par(emit-1,2:end)))<1e-3;fprintf('\n *** converged *** \n');break;end;end
end


if docomp 
	oo = ones(1,Nsample);
	muo = mu*oo; nuo = nu*oo;

	rand('seed',sum(100*clock));
	LLi=zeros(Nsample,1);
	ddl = zeros(Np,Nsj);

		for sj=1:length(A);
			fprintf('subject %i \r',sj)
			a=A{sj};
			r=R{sj};
            s=S{sj};

			est = diag(sqrt(nu))*randn(Np,Nsample)+mu*ones(1,Nsample);
			for k=1:Nsample;
				LLi(k)=feval(ff{whichinf},est(:,k),a,r,s,Z,0);
				if ~mod(k,50);fprintf('subject %i sample %i\r',sj,k);end
			end
			iL(sj) = log(sum(exp(-LLi))/Nsample);
		end


	% compute integrated BIC 
	for k=1:length(A); Nch(k)=length(A{k});end; Nch = Nch(:);	
	bici  = -2*sum(iL)   + Np*log(sum(Nch)); % integrated BIC 

	eval(['save mat/' ld{whichinf} '_meanerror bici iL ddl mu nu E ld ff whichinf']);
end

% quit





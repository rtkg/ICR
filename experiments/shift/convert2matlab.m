clear all; close all; clc;

name{1}='Fish_5k';
% name{2}='RedCup_5k';
% name{3}='ShowerGel_5k';
% name{4}='Sprayflask_5k';
% name{5}='Tortoise_5k';

for i=1:numel(name)
    CT=load(strcat(name{i},'_CT.txt'));
    P=load(strcat(name{i},'_P.txt'));
    regions_pw=textread(strcat(name{i},'_ICR_PW.txt'),'%s','delimiter','\n');
    regions_cc=textread(strcat(name{i},'_ICR_CC.txt'),'%s','delimiter','\n');

    nF=P(1,1); %number of fingers is assumed to be constant over all experiments!!!
    nE=size(P,1); %number of carried out experiments

    %just to check...
    if (nE ~= size(regions_pw,1)/nF) error('Data dimension mismatch'); end

    for e=1:nE
        for n=1:nF
            ind_pw=strread(regions_pw{(e-1)*nF+n});
            ind_cc=strread(regions_cc{(e-1)*nF+n});
            results(e).icr_pw(n).ind=ind_pw;
            results(e).icr_pw(n).N=numel(ind_pw);
            results(e).icr_cc(n).ind=ind_cc;
            results(e).icr_cc(n).N=numel(ind_cc);
            results(e).G(n)=ind_pw(1);% first icr index corresponds to the prototype grasp's contact point
        end    
        results(e).N_pw=sum([results(e).icr_pw.N]);
        results(e).N_cc=sum([results(e).icr_cc.N]);
        results(e).ct_sz=CT(e,1);
        results(e).ct_pw=CT(e,2);
        results(e).ct_cc=CT(e,3);
        results(e).nF=nF;
        results(e).mu=P(e,2);
        results(e).L=P(e,3); %consider the added normal wrench
    end
    save(name{i},'results');
    clear results;
end
%EOF
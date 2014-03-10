clear all; close all; clc;

addpath ../../third_party;

name{1}='Fish_5k';
% name{2}='RedCup_5k';
% name{3}='ShowerGel_5k';
% name{4}='Sprayflask_5k';
% name{5}='Tortoise_5k';

%initialize groups assuming that all experiment sets were performed considering the same L- and
%mu discretizations; grouping is done by friction cone discretization L and friction coefficient mu;
groups = MapN();
R=load(name{1});
L_list=unique([R.results.L]);
mu_list=unique([R.results.mu]);
comb=allcomb(L_list,mu_list);
group.N_pw=[]; group.N_cc=[]; group.ct_sz=[]; group.ct_pw=[]; group.ct_cc=[];
for i=1:size(comb,1)
  groups(comb(i,1),comb(i,2))=group;
end    

for i=1:numel(name)
    R=load(name{i});    
    for e=1:numel(R.results)
        %add data to ghe corresponding group
      group=groups(R.results(e).L,R.results(e).mu);
      group.N_pw=[group.N_pw; R.results(e).N_pw];
      group.N_cc=[group.N_cc; R.results(e).N_cc];
      group.ct_sz=[group.ct_sz; R.results(e).ct_sz];
      group.ct_pw=[group.ct_pw; R.results(e).ct_pw];
      group.ct_cc=[group.ct_cc; R.results(e).ct_cc];
      
      %put the augmented group back in the map
      groups(R.results(e).L,R.results(e).mu)=group;
    end
end

%Fish_5k=load(name{i});
%EOF
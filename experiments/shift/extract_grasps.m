clear all; close all; clc;

savepath='../tilt/';
name{1}='Fish_5k';
% name{2}='RedCup_5k';
% name{3}='ShowerGel_5k';
% name{4}='Sprayflask_5k';
% name{5}='Tortoise_5k';

des_L=8;
des_mu=0.5;

for i=1:numel(name)
    G=[];
    R=load(name{i});
    for e=1:numel(R.results)
        if ((R.results(e).L == des_L) && (R.results(e).mu==des_mu))
            G=[G; R.results(e).G];
        end
    end
    dlmwrite(strcat(savepath,name{i},'_G_',num2str(des_L),'_',num2str(des_mu),'.txt'),G,'delimiter',' ','precision',12,'newline','pc');
end

%EOF
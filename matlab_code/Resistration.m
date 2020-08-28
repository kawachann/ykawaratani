clear
work_pass=char(fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/NIRSport2_PT/brain'));
subname='mkk200211'
file_pass_nirs=char(fullfile(work_pass,subname));
raw_nirs = nirs.io.loadNIRx(file_pass_nirs);
myp = nirs.registration.register2polhemus(raw_nirs.probe, 'digpts.txt');
tbl=nirs.util.depthmap('?', myp);  % "?" is wild card
region = make_sub_region2(tbl, myp);

% for i=1:44
% if region(i,3)~='1'
% region(i,3)=0;
%  end 
%  end
% for i=1:44
% if region(i,2)~='1'
% region(i,2)=0;
%  end 
% end

%% ïWèÄî]
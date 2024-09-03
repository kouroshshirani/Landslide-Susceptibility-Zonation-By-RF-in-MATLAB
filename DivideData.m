%%Data Division%
DATA = xlsread('DATA.xlsx');
[m,n] = size(DATA); 
p = 0.70 ; 
idx = randperm(m); 
Training = DATA(idx(1:round(p*m)),:);
Testing = DATA(idx(round(p*m)+1:end),:); 
TrainX = Training(:,1:13); 
TrainY = Training (:,14); 
TestX = Testing(:,1:13);
TestY = Testing (:,14);

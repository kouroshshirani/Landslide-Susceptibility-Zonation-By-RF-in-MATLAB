% Validation
      % ROC
      % AUC
output = predict(b,TestX);
R_Correlation_Test = corr2(TestY',output');
e = TestY' - output ;
MSE = mean(e.^2);
RMSE = sqrt(MSE);
plotroc(TestY',output')
[tpr,fpr,thresholds] = roc(TestY',output');
x1 = fpr;
y1 = tpr;
auc = trapz(x1,y1);

% Load an example dataset provided with matlab
% load house_dataset
In = TrainX;
Out = TrainY;
%--------------------------------------------------------------------------
leaf = 4;
ntrees = 1000;
fboot = 1;
surrogate ='on';
disp('Training the tree bagger')
b = TreeBagger(...
        ntrees,...
        In,Out,... 
        'Method','regression',...
        'oobvarimp','on',...
        'surrogate',surrogate,...
        'minleaf',leaf,...
        'FBoot',fboot);
%         'Options',paroptions...
%     );
%--------------------------------------------------------------------------
% Estimate Output using tree bagger
disp('Estimate Output using tree bagger')
x=Out;
y=predict(b, In);
name='Bagged Decision Trees Model';
% toc
%--------------------------------------------------------------------------
% calculate the training data correlation coefficient
cct=corrcoef(x,y);
cct=cct(2,1);
%--------------------------------------------------------------------------
% Create a scatter Diagram
disp('Create a scatter Diagram')
% plot the 1:1 line
plot(x,x,'LineWidth',3); 
hold on
scatter(x,y,'filled');
hold off
grid on
set(gca,'FontSize',18)
xlabel('Actual','FontSize',25)
ylabel('Estimated','FontSize',25)
title(['Training Dataset, R^2=' num2str(cct^2,2)],'FontSize',30) 
drawnow
fn='ScatterDiagram';
fnpng=[fn,'.png'];
print('-dpng',fnpng);
%--------------------------------------------------------------------------
% Calculate the relative importance of the input variables
% tic
disp('Sorting importance into descending order')
weights=b.OOBPermutedVarDeltaError;
[B,iranked] = sort(weights,'descend');
% toc
%--------------------------------------------------------------------------
disp(['Plotting a horizontal bar graph of sorted labeled weights.']) 
%--------------------------------------------------------------------------
figure
barh(weights(iranked),'g');
xlabel('Variable Importance','FontSize',30,'Interpreter','latex');
ylabel('Variable Rank','FontSize',30,'Interpreter','latex');
title(['Relative Importance of Inputs in estimating Redshift'],...
    'FontSize',17,'Interpreter','latex');
hold on
barh(weights(iranked(1:9)),'y');
barh(weights(iranked(1:5)),'r');
%--------------------------------------------------------------------------
grid on 
xt = get(gca,'XTick');    
xt_spacing=unique(diff(xt));
xt_spacing=xt_spacing(1);    
yt = get(gca,'YTick');    
ylim([0.25 length(weights)+0.75]);
xl=xlim;
xlim([0 2.5*max(weights)]); 
%--------------------------------------------------------------------------
% Add text labels to each bar
for ii=1:length(weights)
    text(...
        max([0 weights(iranked(ii))+0.02*max(weights)]),ii,...
        ['Column ' num2str(iranked(ii))],'Interpreter','latex','FontSize',11);
end 
%--------------------------------------------------------------------------
set(gca,'FontSize',16)
set(gca,'XTick',0:2*xt_spacing:1.1*max(xl));
set(gca,'YTick',yt);
set(gca,'TickDir','out');
set(gca, 'ydir', 'reverse' )
set(gca,'LineWidth',2);   
drawnow 
%--------------------------------------------------------------------------
fn='RelativeImportanceInputs';
fnpng=[fn,'.png'];
print('-dpng',fnpng);
%--------------------------------------------------------------------------
% Ploting how weights change with variable rank
disp('Ploting out of bag error versus the number of grown trees') 
figure
plot(b.oobError,'LineWidth',2);
xlabel('Number of Trees','FontSize',30)
ylabel('Out of Bag Error','FontSize',30)
title('Out of Bag Error','FontSize',30)
set(gca,'FontSize',16)
set(gca,'LineWidth',2);   
grid on
drawnow
fn='EroorAsFunctionOfForestSize';
fnpng=[fn,'.png'];
print('-dpng',fnpng);

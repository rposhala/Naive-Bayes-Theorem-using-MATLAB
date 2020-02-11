clear all
close all
format long
load('data.mat') % loading data.mat

%%%%%%% NORMALIZING F1 DATA %%%%%%%%%%
% normalized F1 data of each subject using the standard normal formulation has been stored in Z1.
Z1 = (F1-(mean(F1,2)))./(std(F1,0,2));

%%%%%%% PLOTTING DISTRIBUTION OF DATA USING F1 AND F2 %%%%%%%%%%%%%
figure('name','F1 Vs F2');
plot(F1,F2,'o');
xlabel('DATA OF F1');
ylabel('DATA OF F2');
title('Fig 4 : DISTRIBUTION OF DATA F1 Vs F2');
legend({'Class 1','Class 2','Class 3','Class 4','Class 5'});

%%%%%%% PLOTTING DISTRIBUTION OF DATA USING Z1 AND F2 %%%%%%%%%%%%%
figure('name','Z1 Vs F2');
plot(Z1,F2,'o');
xlabel('DATA OF Z1');
ylabel('DATA OF F2');
title('Fig 5 : DISTRIBUTION OF DATA Z1 Vs F2');
legend({'Class 1','Class 2','Class 3','Class 4','Class 5'});

%%%%%%% PLOTTING DISTRIBUTION OF F1 DATA %%%%%%%%
figure('name','DISTRIBUTION OF F1 DATA');
plot(F1,'o');
xlabel('Participants (Subjects)');
ylabel('Measurement');
title('Fig 1 : DISTRIBUTION OF F1 DATA');
legend({'Class 1','Class 2','Class 3','Class 4','Class 5'});
%%%%%%% PLOTTING DISTRIBUTION OF Z1 DATA %%%%%%%%
figure('name','DISTRIBUTION OF Z1 DATA');
plot(Z1,'o');
xlabel('Participants (Subjects)');
ylabel('Measurement');
title('Fig 3 : DISTRIBUTION OF Z1 DATA');
legend({'Class 1','Class 2','Class 3','Class 4','Class 5'});
%%%%%%% PLOTTING DISTRIBUTION OF F2 DATA %%%%%%%%
figure('name','DISTRIBUTION OF F2 DATA');
plot(F2,'o');
xlabel('Participants (Subjects)');
ylabel('Measurement');
title('Fig 2 : DISTRIBUTION OF F2 DATA');
legend({'Class 1','Class 2','Class 3','Class 4','Class 5'});


%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA F1 %%%%%%%%%%
accuracy_F1 = accuracy(F1); %% classification accuracy of F1
error_F1 = 1-accuracy_F1; %% Error rate of F1 classification
percentage_accuracy_F1 = accuracy_F1*100; %% converting accuracy to percentage to display

%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA Z1 %%%%%%%%%%
accuracy_Z1 = accuracy(Z1); %% classification accuracy of Z1
error_Z1 = 1-accuracy_Z1; %% Error rate of Z1 classification
percentage_accuracy_Z1 = accuracy_Z1*100; %% converting accuracy to percentage to display

%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA F2 %%%%%%%%%%
accuracy_F2 = accuracy(F2);  %% classification accuracy of F2
error_F2 = 1-accuracy_F2; %% Error rate of F2 classification
percentage_accuracy_F2 = accuracy_F2*100; %% converting accuracy to percentage to display

%%%%%% CALCULATING CLASSIFICATION ACCURACY OF DATA [Z1 F2] (WHICH IS A MULTIVARIATE NORMAL DISTRIBUTION)%%%%%%%%%%
correct_Z1F2 = 0;           %% INITIALIZING A VARIABLE 'CORRECT_Z1F1' %%%%
mean_F2 = mean(F2(1:100,:));
mean_Z1 = mean(Z1(1:100,:));
std_F2 = std(F2(1:100,:)); 
std_Z1 = std(Z1(1:100,:)); 
for i = 1:5                 %% ITERATING THE DATA BY EACH COLUMN (CLASS) FOR Z1 AND F2 DATA%%%%
    x = zeros(900,5);       %% INITIALIZING A VECTOR X OF SIZE 900 X 5 TO STORE PROBABILITY OF EACH ELEMENT(MEASUREMENT) ACROSS ALL 5 CLASSES FOR F2 DATA %%%%%
    z = zeros(900,5);       %% INITIALIZING A VECTOR Z OF SIZE 900 X 5 TO STORE PROBABILITY OF EACH ELEMENT(MEASUREMENT) ACROSS ALL 5 CLASSES FOR Z1 DATA %%%%%
    for j = 1:5             %% ITERATING DATA OF EACH CLASS ACROSS ALL THE CLASSES %%%%
        x(:,j) = pdf('Normal',F2(101:1000,i),mean_F2(j),std_F2(j));  %% CALCULATING PROBABILITY OF EACH CLASS (FOR SUBJECTS 101 TO 1000(900 DATA POINTS)) ACROSS ALL THE CLASS DISTRIBUTIONS FOR F2 DATA AND STORING THEM IN X MATRIX%%%%
        z(:,j) = pdf('Normal',Z1(101:1000,i),mean_Z1(j),std_Z1(j));  %% CALCULATING PROBABILITY OF EACH CLASS (FOR SUBJECTS 101 TO 1000(900 DATA POINTS)) ACROSS ALL THE CLASS DISTRIBUTIONS FOR Z1 DATA AND STORING THEM IN Z MATRIX%%%%
        y = x.*z;           %% CALCULATING PROBABILITY OF EACH CLASS OF BOTH Z1 AND F2 DATA (AS F2 AND Z1 DATA ARE INDEPENDENT THE PROBABILITIES ARE MULTIPLIED) %%%
    end
    [M,index] = max(y,[],2);%% DERIVING THE MAXIMUM VALUE AND INDEX (CLASS NUMBER) OF PROBABILITIES FOR EACH SUBJECT %%%%
    
    for k = 1:length(index) %% ITERATING THE CALSSIFIED CLASSES OF EACH ELEMENT OF CLASS I %%%%
       if index(k) == i     %% CHECKING WHETHER AN ELEMENT OF A CLASS IS CLASSIFIED AS ITS OWN CLASS(WHICH IS CORRECT) %%%%
          correct_Z1F2 = correct_Z1F2 + 1 ; %% COUNTING THE CORRECT CLASSIFICATION %%
       end
    end
end
accuracy_Z1F2 = correct_Z1F2/4500;             %% CALCULATING THE CLASSIFICATION ACCURACY OF THE DATA Z1 AND F2 %%%%
error_Z1F2 = 1-accuracy_Z1F2;                  %% ERROR RATE of Z1 AND F2 CLASSIFICATION %%
percentage_accuracy_Z1F2 = accuracy_Z1F2*100;  %% CONVERTING ACCURACY TO PERCENTAGE TO DISPLAY %%

%%%% DISPLAYING A TABLE COMPARING CLASSIFICATION RATE FOR ALL FOUR CASES %%%%
Classification_rate = table(percentage_accuracy_F1,percentage_accuracy_Z1,percentage_accuracy_F2,percentage_accuracy_Z1F2)

%%%%%%% FUNCTION TAKES DATA AS INPUT AND RETURNS ITS CLASSIFICATION ACCURACY %%%%%%%%
function acc = accuracy(X)
    m = mean(X(1:100,:));       %% CALCULATING MEAN OF FIRST 100 SUBJECTS OF A DISTRIBUTION %%%%
    s = std(X(1:100,:));        %% CALCULATING STANDARD DEVIATION OF FIRST 100 SUBJECTS OF A DISTRIBUTION %%%%
    correct = 0;                %% INITIALIZING A VARIABLE 'CORRECT' %%%%
    for i = 1:5                 %% ITERATING THE DATA BY EACH COLUMN (CLASS) %%%%
        y = zeros(900,5);       %% INITIALIZING A VECTOR Y OF SIZE 900 X 5 TO STORE PROBABILITY OF EACH ELEMENT(MEASUREMENT) ACROSS ALL 5 CLASSES %%%
        for j = 1:5             %% ITERATING DATA OF EACH CLASS ACROSS ALL THE CLASSES %%%%
            y(:,j) = pdf('Normal',X(101:1000,i),m(j),s(j)); %% CALCULATING PROBABILITY OF EACH CLASS (FOR SUBJECTS 101 TO 1000(900 DATA POINTS)) ACROSS ALL THE CLASS DISTRIBUTIONS AND STORING THEM IN Y MATRIX%%%%
        end
        [M,index] = max(y,[],2);%% DERIVING THE MAXIMUM VALUE AND INDEX (CLASS NUMBER) OF PROBABILITIES FOR EACH SUBJECT %%%%

        for k = 1:length(index) %% ITERATING THE CALSSIFIED CLASSES OF EACH ELEMENT OF CLASS I %%%%
           if index(k) == i     %% CHECKING WHETHER AN ELEMENT OF A CLASS IS CLASSIFIED AS ITS OWN CLASS(WHICH IS CORRECT) %%%%
              correct = correct + 1 ; %% COUNTING THE CORRECT CLASSIFICATION %%
           end
        end
    end
    acc = correct/4500;         %% CALCULATING AND RETURNING THE CLASSIFICATION ACCURACY OF THE ENTIRE DATA WHICH IS GIVEN AS INPUT %%%%

end

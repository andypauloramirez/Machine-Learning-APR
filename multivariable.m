%% Machine Learning: Discriminante gaussiano - Andy Paulo Ramirez
close all
clc
%% Bayes multivariable
tic
%% Discriminante gausiano
Data= xlsread('Cardio train.xlsx','A2:D70001'); %[cardio,edad, altura, peso]
r=size(Data,1);
%aleatorizamos la data
Datarandom=Data(randperm(r),:);

train=Datarandom(1:50000,:); %[cardio, edad, altura, peso]
cardio=train(:,1);
age=train(:,2);
height=train(:,3);
weight=train(:,4);
test=Datarandom(50001:70000,:);
%features
cardiotest=test(:,1);
agetest=test(:,2);
heighttest=test(:,3);
weighttest=test(:,4);

%probabilidad de que no tenga una enfermedad cardiovascular P(c0)
Pc0=sum(cardio==0)/size(cardio,1);
%probabilidad de que tenga una enfermedad cardiovascular P(c1)
Pc1=1-Pc0;

%% Para los sanos 0 y los enfermos 1 
%caracteristica elegida--> x=Peso

cont2=1;cont1=1;dist0=[];dist1=[];

for i=1:size(train,1)
    if train(i,1)==0
        dist0(cont1,:)=train(i,2:4); %distribucion sin problemas
        cont1=cont1+1;
    else
        dist1(cont2,:)=train(i,2:4); %distribucion con problemas
        cont2=cont2+1;
    end      
end

%% Probabilidad de que segun el peso y altura no esté enfermo
mu0 = mean(dist0(:,2:3));
covarianza0= cov(dist0(:,2:3));
invcov0=inv(covarianza0);
for i=1:size(test,1)
distancia=test(i, 3:4)-mu0;
%likelihood para los que no tienen problemas
likelihood0(i,1) = exp(-0.5.*distancia*invcov0*transpose(distancia))*(1/(2*pi*sqrt(det(covarianza0))));
end
Prob0x1x2=Pc0*likelihood0;

%% Probabilidad de que segun el peso,edad y altura no esté enfermo
mu1 = mean(dist1(:,2:3));
covarianza1= cov(dist1(:,2:3));
invcov1=inv(covarianza1);
for i=1:size(test,1)
distancia1=test(i, 3:4)-mu1;
%likelihood para los que no tienen problemas
likelihood1(i,1) = exp(-0.5.*distancia1*invcov1*transpose(distancia1))*(1/(2*pi*sqrt(det(covarianza1))));
end
Prob1x1x2=Pc1*likelihood1;

%% Clasificacion 0 1 ----> x(altura y peso)
clasificacion2=[];
for i=1:size(Prob1x1x2,1)
if Prob1x1x2(i)>Prob0x1x2(i)
    clasificacion2(i,1)=1;
else 
    clasificacion2(i,1)=0;
end
end
acierto_2_variables= mean(clasificacion2==test(:,1))*100

subplot(2,1,1)
plot3(test(:,3),test(:,4),likelihood0, 'black*')
xlabel('Altura')
ylabel('Peso')
zlabel('Prob') 
title('Distribucion normal de P(C0/altura,peso)')
grid on

subplot(2,1,2)
plot3(test(:,3),test(:,4),likelihood1, 'm*')
xlabel('Altura')
ylabel('Peso')
zlabel('Prob') 
title('Distribucion normal de P(C1/altura,peso)')
grid on

%% Para 3 variables

%%Probabilidad de que segun el peso y altura y edad no esté enfermo
mu30 = mean(dist0);
covarianza30= cov(dist0);
invcov30=inv(covarianza30);
for i=1:size(test,1)
distancia3=test(i, 2:4)-mu30;
%likelihood para los que no tienen problemas
likelihood30(i,1) = exp(-0.5.*distancia3*invcov30*transpose(distancia3))*(1/(2*pi*sqrt(det(covarianza30))));
end
Prob03x1x2=Pc0*likelihood30;

%%Probabilidad de que segun el peso y altura  y edad  esté enfermo
mu31 = mean(dist1);
covarianza31= cov(dist1);
invcov31=inv(covarianza31);
for i=1:size(test,1)
distancia31=test(i, 2:4)-mu31;
%likelihood para los que no tienen problemas
likelihood31(i,1) = exp(-0.5.*distancia31*invcov31*transpose(distancia31))*(1/(2*pi*sqrt(det(covarianza31))));
end
Prob13x1x2=Pc1*likelihood31;

%clasificacion 
clasificacion3=[];
for i=1:size(Prob13x1x2,1)
if Prob13x1x2(i)>Prob03x1x2(i)
    clasificacion3(i,1)=1;
else 
    clasificacion3(i,1)=0;
end
end
acierto_3_variables= mean(clasificacion3==test(:,1))*100



toc
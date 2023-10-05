%% Machine Learning: Discriminante gaussiano - Andy Paulo Ramirez
close all
clc
tic
%% Discriminante gausiano

Data= xlsread('Cardio train.xlsx','A2:D70001');
r=size(Data,1);
Datarandom=Data(randperm(r),:);
%%
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

%% 1 Probabilidad de que segun la edad no esté enfermo para la edad
muage0 = mean(dist0(:,1));
sigmaage0 = std(dist0(:,1));

%likelihood para los que no tienen problemas
Pxc0age = exp(-(test(:,2)-muage0).^2./(2.*sigmaage0.^2))./(sigmaage0*sqrt(2*pi));
Pc0xage=Pc0*Pxc0age;

%Probabilidad de que segun el edad esté enfermo 
muage1 = mean(dist1(:,1));
sigmaage1 = std(dist1(:,1));
%likelihood para los que tienen problemas
Pxc1age = exp(-(test(:,2)-muage1).^2./(2*sigmaage1.^2))./(sigmaage1*sqrt(2*pi));
Pc1xage=Pc1*Pxc1age;

%% 2 Probabilidad de que segun la edad no esté enfermo para el altura
muheight0 = mean(dist0(:,2));
sigmaheight0 = std(dist0(:,2));

%likelihood para los que no tienen problemas
Pxc0height = exp(-(test(:,3)-muheight0).^2./(2.*sigmaheight0.^2))./(sigmaheight0*sqrt(2*pi));
Pc0xheight=Pc0*Pxc0height;

%Probabilidad de que segun el edad esté enfermo 
muheight1 = mean(dist1(:,2));
sigmaheight1 = std(dist1(:,2));
%likelihood para los que tienen problemas
Pxc1height = exp(-(test(:,3)-muheight1).^2./(2*sigmaheight1.^2))./(sigmaheight1*sqrt(2*pi));
Pc1xheight=Pc1*Pxc1height;

%% 3 Probabilidad de que segun la edad no esté enfermo para el peso
muweight0 = mean(dist0(:,3));
sigmaweight0 = std(dist0(:,3));

%likelihood para los que no tienen problemas
Pxc0weight = exp(-(test(:,4)-muweight0).^2./(2.*sigmaweight0.^2))./(sigmaweight0*sqrt(2*pi));
Pc0xweight=Pc0*Pxc0weight;

%Probabilidad de que segun el edad esté enfermo 
muweight1 = mean(dist1(:,3));
sigmaweight1 = std(dist1(:,3));
%likelihood para los que tienen problemas
Pxc1weight = exp(-(test(:,4)-muweight1).^2./(2*sigmaweight1.^2))./(sigmaweight1*sqrt(2*pi));
Pc1xweight=Pc1*Pxc1weight;

%% Prediccion para edad
clasificacionage=[];
for i=1:size(Pc1xage,1)
if Pc1xage(i)>Pc0xweight(i)
    clasificacionage(i,1)=1;
else 
    clasificacionage(i,1)=0;
end
end
aciertoage= mean(clasificacionage==cardiotest)*100;

%% Prediccion para altura
clasificacionweight=[];
for i=1:size(Pc1xheight,1)
if Pc1xheight(i)>Pc0xheight(i)
    clasificacionweight(i,1)=1;
else 
    clasificacionweight(i,1)=0;
end
end
aciertoheight= mean(clasificacionweight==cardiotest)*100;


%% Prediccion para peso
clasificacionparapeso=[];
for i=1:size(Pc1xweight,1)
if Pc1xweight(i)>Pc0xweight(i)
    clasificacionparapeso(i,1)=1;
else 
    clasificacionparapeso(i,1)=0;
end
end
aciertoweight= mean(clasificacionparapeso==cardiotest)*100;

%% Histograma para altura

%histogramas para la distribucion de cada clase
legend
histogram(dist0(:, 2))
hold on
legend
histogram(dist1(:, 2))
hold off
plot(heighttest,Pxc0height,'black*')
hold on
plot(heighttest,Pxc1height,'m*')
legend ('Sanos','Enfermos' )
hold off

%% Histograma para edad

%histogramas para la distribucion de cada clase
legend
histogram(dist0(:, 1))
hold on
legend
histogram(dist1(:, 1))
hold off
plot(agetest,Pxc0age,'black*')
hold on
plot(agetest,Pxc1age,'m*')
legend ('Sanos','Enfermos' )
hold off

%% Histograma para peso

%histogramas para la distribucion de cada clase
legend
histogram(dist0(:, 3))
hold on
legend
histogram(dist1(:, 3))
hold off
plot(weighttest,Pxc0weight,'black*')
hold on
plot(weighttest,Pxc1weight,'m*')
legend ('Sanos','Enfermos' )
hold off

toc

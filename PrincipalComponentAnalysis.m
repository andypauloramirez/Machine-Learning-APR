%% Machine Learning: Reducción de dimensionalidad - Andy Paulo Ramirez
close all
clc
clear 

%% Principal Component Analysis
%Importando la data 
dataset = readmatrix('cardio_train.csv');
dataset = dataset(randperm(height(dataset)),[2,3,4,5,6,7,9,10,11,12,8]);
train = dataset(1:35000,:);
test = dataset(35001:end,:);
target = dataset(:,end);
input = dataset(:,1:(end-1));
k=10;
kred=3; 
sigma(height(train),width(train)-1)=0;
aciertos=0;
dist(height(train))=0;
%knn: Clasificación con el dataset sin reducirle la dimensionalidad usando k=10
for i = 1:height(test)
    diferencia = (train(:,1:(end-1))-test(i,1:(end-1))).^2;
    sigma = sum(diferencia,2);
    dist = sqrt(sigma);
    [minimo, Indice] = mink (dist,k);
    clasificador(i) = mode (train(Indice,end));
    if clasificador (i) == test(end)
        aciertos = aciertos+1;
    end
end
display(aciertos)
porcentaje = (aciertos/(height(test)))*100;
display(porcentaje)
%Aplicando PCA 
%Hallamos la matriz de covarianza 
m = ((sum(train(:,1:(end-1)))')./(height(train)))';
for i=1:(width(train)-1)
    for u = 1:(width(train)-1)
        covmatrix(i,u)=sum((train(:,i)-m(i)).*(train(:,u)-m(u)))./(height(train)); 
    end
end
%Hallamos los eigen vectors y eigen values de la matriz de cov para hallar
%W
[vec, val]=eig(covmatrix);
val = diag(val);
[minimored eigmaximo]=maxk(val,kred);

%Determinamos la matriz W que se multiplicará por nuestro dataset para
%tener al nuevo set z reducido
w = vec(:,[eigmaximo]);
w = transpose(w);
zset = w*train(:,1:(end-1))';
zset = transpose(zset);
zset(:,end+1)=train(:,end);

Q = w*test(:,1:(end-1))';
Q = transpose(Q);
Q(:,end+1) = test(:,end);

redsigma=0;
redaciertos=0;
reddist(height(zset))=0;

 for i = 1:height(Q)
    diferencia = (zset(:,1:(end-1))-Q(i,1:(end-1))).^2;
    redsigma = sum(diferencia,2);
    reddist = sqrt(redsigma);
    [minimo, Indice] = mink (reddist,k);
    clasificador(i) = mode (zset(Indice,end));
    if clasificador (i) == Q(end)
        redaciertos = redaciertos+1;
    end
end
display(redaciertos)
redporcentaje = (redaciertos/(height(Q)))*100;
display(redporcentaje)
%Computando el error mediocuadrado para tener las mismas métricas de comparación que
%NNtool
clasificador = transpose(clasificador);
mse = (sum((clasificador-test(:,end)).^2))/(height(test));
display(mse)

%% Comparacion de desempeno con NNtool

%Iniciamos la herramienta Neural Net 

nn = nftool;


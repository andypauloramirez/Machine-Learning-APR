%% Machine Learning: Reducción de dimensionalidad - Andy Paulo Ramirez
close all
clc
clear 

%% Lineal Discriminant Analysis

%Importando la data 
dataset = readmatrix('cardio_train.csv');
dataset = dataset(randperm(height(dataset)),[2,3,4,5,6,7,9,10,11,12,8]);
train = dataset(1:35000,:);
test = dataset(35001:end,:);
target = dataset(:,end);
input = dataset(:,1:(end-1));
k=10;
kred=3; 
sigma = 0;
aciertos=0;
dist(height(train))=0;
Sw = 0;
Sb = 0;

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
% Aplicando LDA
numclase(length(min(train(:,end)):max(train(:,end)))) = 0;
clase(:,width(train),length(numclase)) = 0;
valmin = min(train(:,end));
valmax = max(train(:,end));

for j = valmin:valmax
    for i = 1:height(train)
        if train(i,end)== j
            numclase(j)=numclase(j)+1;
            clase(i,:,j)=train(i,:);
        end
    end
end
%Hallamos a Sw que viene dado por la sumatioria de las varianzas de las
%clases

for j = valmin:valmax
    Mi(j,:)=sum(clase(:,1:(end-1),j))./(height(clase));
    for i = 1:height(clase(:,:,j))
        Sw = Sw+((clase(i,1:(end-1),j) - Mi(j,:))')*(clase(i,1:(end-1),j) - Mi(j,:));
    end
end
%Calculamos la media general(media de todas las medias de cada clase)

mediagen = sum(Mi)/(valmax);

% Hallamos a Sb que viene dado por la sumatoria del producto de la resta de la media de
% cada clase y la media general y su traspuesta

for j = valmin:valmax
    Sb = Sb + numclase(j).*(((Mi(j,:)-mediagen)')*(Mi(j,:)-mediagen));
end

% Hallamos el nuevo dataset

[vec,val] = eig((inv(Sw))*Sb);  %computamos los egenvectors y eigenvalues
val = diag(val);
[minimored eigmaximo]=maxk(val,kred);

%Determinamos la matriz W que se multiplicará por nuestro dataset para
%tener a Z
w = vec(:,[eigmaximo]);
w = transpose(w);
zset = w*train(:,1:(end-1))';
zset = transpose(zset);
zset(:,end+1)=train(:,end);

Q = w*test(:,1:(end-1))';
Q = transpose(Q);
Q(:,end+1) = test(:,end);

%knn: Clasificación con el dataset con reduccion la dimensionalidad usando k=10
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

%Computando el error medio cuadrado para tener las mismas métricas de comparación que
%NNtool
clasificador = transpose(clasificador);
mse = (sum((clasificador-test(:,end)).^2))/(height(test));
display(mse)
%% Comparacion de desempeno con NNtool

%Iniciamos la herramienta Neural Net 

nn = nftool;



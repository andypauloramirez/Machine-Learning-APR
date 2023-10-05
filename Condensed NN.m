Trainset=xlsread('knn_dataset','Programming_exercise','A3:E70002');
Testset=xlsread('knn_dataset','Programming_exercise','H3:L20002');

X = Trainset(randperm(size(Trainset,1)),:); %Se elige aleatoriamente el primer elemento de X que iniciaizará el dataset Z
sizeZ = zeros(size(Trainset,1)/2,5); % Prealocalizacion de la variable Z
Descartados = zeros(size(Trainset,1)/2,1);% Elementos descartados
sizeZ(1,:) = X(1,:); %El primer valor de Z es el primer valor de X
X(1,:) = []; %Se elimina el valor de X tomado
flag = 1;    %Flag para controlar el bucle
k = 1;       %Valor de k para tomar el vecino mas cercano
j = 1;       %Variable para indexar el array Descartados

tic          %Tomando el tiempo

while flag == 1
    flag = 0;   % Se pone el flag en 0
    Descartados(:,:)=0; %
    i = 1;
    j = 1;
    X = X(randperm(size(X,1)),:); %Se permuta aleatoriamente X

    while i < size(X,1)
 %Indices mas cercanos entre el x evaluado y todo los datos de Z
        KNNi = KNN(X(i,3:5),sizeZ(:,3:5),k);
 %Se toma el genero de Z del indice correspondiente
        GeneroMasCercano = sizeZ(KNNi,2);
        if GeneroMasCercano == X(i,2) % Si el genero de x concuerda
            i = i + 1;  %Se continua la iteracion
        elseif GeneroMasCercano ~= X(i,2) %Si no concuerda
  %Se añade el dato evaluado de x a Z
            sizeZ(size(sizeZ(sizeZ(:,1)~=0),1)+1,:) = X(i,:);
  %Se añade el valor del indice de x a la matriz de descartados
            Descartados(j,1) = i;
            i = i+1;
            j = j+1;
            disp(size(sizeZ(sizeZ(:,1)~=0),1))
  %Se vuelve a poner el flag en 1 para repetir el ciclo principal
            flag = 1;
         end
     end
  %Se eliminan los valores de X cuyos indices sean iguales a los guardados en Descartados
     X(Descartados(Descartados(:,1)~=0,:),:)=[];
 end
 disp('Condensación lista')
 toc
% Valores de trabajo
k = 15;  % Valor de K
sizeTest = size(Testset,1);   %Tamaño del TestSet
sizeTrain = size(Trainset,1); %Tamaño del TrainSet
sizeZ = size(sizeZ,1);            %Tamaño de Z
CordsTest = Testset(:,3:5);     %Coordenadas a utilizar (peso altura y alcohol)
CordsTrain = Trainset(:,3:5);
CordsZ = sizeZ(:,3:5);
GenerosResultantesKNN = zeros(sizeTest,k); %Vector para guardar los Generos Resultantes
GenerosResultantesCNN = zeros(sizeTest,k);
GenerosReales = Testset(:,2); %Generos Reales del TestSet
AciertosKNN=zeros(k,1);
AciertosCNN=zeros(k,1);
tic
for i =1:sizeTest  %Bucle que se ejecuta para cada dato del testset
    KNNi = KNN(CordsTest(i,:),CordsTrain,k);
    for j = 1:k
        KNNgeneros = Trainset(KNNi(1:j),2);
        GeneroEsperado = mode(KNNgeneros); %Genero esperado segun el genero que mas se repite en los K vecinos mas cercanos
        GenerosResultantesKNN(i,j)=GeneroEsperado;%Se añade el genero esperado calculado al vector de generos resultantes
    end
end
disp('FIN kNN');
for i = 1:k
    AciertosKNN(i,1) = mean(GenerosReales==GenerosResultantesKNN(:,i)); %Tasa de aciertos
end
tiempoknn = toc;
tic
for i =1:sizeTest  %Bucle que se ejecuta para cada dato del testset
    KNNi = KNN(CordsTest(i,:),CordsZ,k);
    for j = 1:k
        KNNgeneros = sizeZ(KNNi(1:j),2);
        GeneroEsperado = mode(KNNgeneros); %Genero esperado segun el genero que mas se repite en los K vecinos mas cercanos
        GenerosResultantesCNN(i,j)=GeneroEsperado;%Se añade el genero esperado calculado al vector de generos resultantes
    end
end
disp('Fin CNN');
for i = 1:k
    AciertosCNN(i,1) = mean(GenerosReales==GenerosResultantesCNN(:,i)); %Tasa de aciertos
end
tiempocnn = toc;
% Funcion de KNN
function KNNi = KNN(PuntoPrueba, TrainSetCords,k)
    % Formula distancia euclideana
    Distancias = sum((PuntoPrueba-TrainSetCords).^2,2);
    % Organizar indices de distancias de menor a mayor
    [~,indices] = sort(Distancias);
    KNNi = indices(1:k); %Output de la funcion
end
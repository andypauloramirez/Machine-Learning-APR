
%% Importacion de la data (1ra permutacion de datos)
clear 
clc
Datos = importdata('Data.xlsx');
Headers = Datos.colheaders.Hoja1(1,1:end-2);
Training_data = Datos.data.Hoja1(:,1:8);
Training_data = array2table(Training_data,'VariableNames',Headers);
Training_data(round(length(Training_data.mpg)*0.75+1):end,:) = [];
Test_data = Datos.data.Hoja1(:,1:8);
Test_data = array2table(Test_data,'VariableNames',Headers);
Test_data(1:round(length(Test_data.mpg)*0.75-1),:) = [];
Train_Pred = Training_data.mpg;
Test_Pred = Test_data.mpg;

%% Estandarizacion de los datos
a = max(Training_data.cylinders);
b = min(Training_data.cylinders);
a1 = max(Training_data.Displacement);
b1 = min(Training_data.Displacement);
a2 = max(Training_data.Horsepower);
b2 = min(Training_data.Horsepower);
a3 = max(Training_data.Weight);
b3 = min(Training_data.Weight);
a4 = max(Training_data.Acceleration);
b4 = min(Training_data.Acceleration);
a5 = max(Training_data.Model);
b5 = min(Training_data.Model);
a6 = max(Training_data.Origin);
b6 = min(Training_data.Origin);
for i=1:+1:numel(Train_Pred)
    Training_data.cylinders(i) = (Training_data.cylinders(i)-b)/(a-b);
    Training_data.Displacement(i) = (Training_data.Displacement(i)-b1)/(a1-b1);
    Training_data.Horsepower(i) = (Training_data.Horsepower(i)-b2)/(a2-b2);
    Training_data.Weight(i) = (Training_data.Weight(i)-b3)/(a3-b3);
    Training_data.Acceleration(i) = (Training_data.Acceleration(i)-b4)/(a4-b4);
    Training_data.Model(i) = (Training_data.Model(i)-b5)/(a5-b5);
    Training_data.Origin(i) = (Training_data.Origin(i)-b6)/(a6-b6);
end

a = max(Test_data.cylinders);
b = min(Test_data.cylinders);
a1 = max(Test_data.Displacement);
b1 = min(Test_data.Displacement);
a2 = max(Test_data.Horsepower);
b2 = min(Test_data.Horsepower);
a3 = max(Test_data.Weight);
b3 = min(Test_data.Weight);
a4 = max(Test_data.Acceleration);
b4 = min(Test_data.Acceleration);
a5 = max(Test_data.Model);
b5 = min(Test_data.Model);
a6 = max(Test_data.Origin);
b6 = min(Test_data.Origin);
for i=1:+1:numel(Test_Pred)
    Test_data.cylinders(i) = (Test_data.cylinders(i)-b)/(a-b);
    Test_data.Displacement(i) = (Test_data.Displacement(i)-b1)/(a1-b1);
    Test_data.Horsepower(i) = (Test_data.Horsepower(i)-b2)/(a2-b2);
    Test_data.Weight(i) = (Test_data.Weight(i)-b3)/(a3-b3);
    Test_data.Acceleration(i) = (Test_data.Acceleration(i)-b4)/(a4-b4);
    Test_data.Model(i) = (Test_data.Model(i)-b5)/(a5-b5);
    Test_data.Origin(i) = (Test_data.Origin(i)-b6)/(a6-b6);
end
clear a a1 a2 a3 a4 a5 a6 b b1 b2 b3 b4 b5 b6
%% Computacion de los pesos y resultados
Train_features = [Training_data.Weight,Training_data.Displacement,Training_data.Horsepower,Training_data.cylinders,Training_data.Acceleration,Training_data.Model,Training_data.Origin];
Test_features = [Test_data.Weight,Test_data.Displacement,Test_data.Horsepower,Test_data.cylinders,Test_data.Acceleration,Test_data.Model,Test_data.Origin];

j = 1;
for i=2:+1:numel(Train_Pred-1)
    [Resultados_Train,Pesos_Train] = weight(Train_features(1:i,:),Train_Pred(1:i));
    Error_Entrenamiento(j,1) =  mean((Train_Pred(1:i)-Resultados_Train).^2);
    D1 = ones(numel(Test_Pred),1);
    D1 = [D1,Test_features];
    Resultados_Test = D1*Pesos_Train;
    Error_Test(j,1) = mean((Test_Pred-Resultados_Test).^2);
    j = j+1;
end
%% Curvas de aprendizaje
% Nota:
%
% Hay un dato mas de entrenamiento que de test, debido a que el valor de
% test practicamente dobla el error de entrenamiento, sin embargo se puede
% apreciar el comportamiento
figure
plot(Error_Entrenamiento(6:26))
hold on
plot(Error_Test(6:26))
hold off
xlabel('Cantidad de muestras')
ylabel('Porcentaje de error')
title('Curva de aprendizaje')
legend('Entrenamiento','Test')
%% Aplicacion de kNN para la primera permutacion de datos
k = 1;
a = 1;
for j=1:+5:numel(Train_Pred)
    Train_features = [Training_data.Weight(1:j),Training_data.Displacement(1:j),Training_data.Horsepower(1:j),Training_data.cylinders(1:j),Training_data.Acceleration(1:j),Training_data.Model(1:j),Training_data.Origin(1:j)];
        for i=1:+1:numel(Test_Pred)
            Distancia = sum(abs(Train_features-Test_features(i,:)),2);
            Mat = [Distancia,Train_Pred(1:j)];
            Mat = sortrows(Mat,1);
            Sol(i,1) = mean(Mat(1:k,2));
        end
        Error_kNN(a,1) = mean((Test_Pred(i)-Sol(i)).^2);
        a = a+1;
end
%% Curva de aprendizaje para el kNN
plot(Error_kNN)
xlabel('Cantidad de muestras')
ylabel('% de aciertos')
title('Curva de aprendizaje')
%% Importacion de la data (2da permutación)
clear 
clc
Datos = importdata('Data.xlsx');
Headers = Datos.colheaders.Hoja2(1,1:end-2);
Training_data = Datos.data.Hoja2(:,1:8);
Training_data = array2table(Training_data,'VariableNames',Headers);
Training_data(round(length(Training_data.mpg)*0.75+1):end,:) = [];
Test_data = Datos.data.Hoja2(:,1:8);
Test_data = array2table(Test_data,'VariableNames',Headers);
Test_data(1:round(length(Test_data.mpg)*0.75-1),:) = [];
Train_Pred2 = Training_data.mpg;
Test_Pred2 = Test_data.mpg;
%% Estandarizacion de los datos (2da permutación)
a = max(Training_data.cylinders);
b = min(Training_data.cylinders);
a1 = max(Training_data.Displacement);
b1 = min(Training_data.Displacement);
a2 = max(Training_data.Horsepower);
b2 = min(Training_data.Horsepower);
a3 = max(Training_data.Weight);
b3 = min(Training_data.Weight);
a4 = max(Training_data.Acceleration);
b4 = min(Training_data.Acceleration);
a5 = max(Training_data.Model);
b5 = min(Training_data.Model);
a6 = max(Training_data.Origin);
b6 = min(Training_data.Origin);
for i=1:+1:numel(Train_Pred2)
    Training_data.cylinders(i) = (Training_data.cylinders(i)-b)/(a-b);
    Training_data.Displacement(i) = (Training_data.Displacement(i)-b1)/(a1-b1);
    Training_data.Horsepower(i) = (Training_data.Horsepower(i)-b2)/(a2-b2);
    Training_data.Weight(i) = (Training_data.Weight(i)-b3)/(a3-b3);
    Training_data.Acceleration(i) = (Training_data.Acceleration(i)-b4)/(a4-b4);
    Training_data.Model(i) = (Training_data.Model(i)-b5)/(a5-b5);
    Training_data.Origin(i) = (Training_data.Origin(i)-b6)/(a6-b6);
end

a = max(Test_data.cylinders);
b = min(Test_data.cylinders);
a1 = max(Test_data.Displacement);
b1 = min(Test_data.Displacement);
a2 = max(Test_data.Horsepower);
b2 = min(Test_data.Horsepower);
a3 = max(Test_data.Weight);
b3 = min(Test_data.Weight);
a4 = max(Test_data.Acceleration);
b4 = min(Test_data.Acceleration);
a5 = max(Test_data.Model);
b5 = min(Test_data.Model);
a6 = max(Test_data.Origin);
b6 = min(Test_data.Origin);
for i=1:+1:numel(Test_Pred2)
    Test_data.cylinders(i) = (Test_data.cylinders(i)-b)/(a-b);
    Test_data.Displacement(i) = (Test_data.Displacement(i)-b1)/(a1-b1);
    Test_data.Horsepower(i) = (Test_data.Horsepower(i)-b2)/(a2-b2);
    Test_data.Weight(i) = (Test_data.Weight(i)-b3)/(a3-b3);
    Test_data.Acceleration(i) = (Test_data.Acceleration(i)-b4)/(a4-b4);
    Test_data.Model(i) = (Test_data.Model(i)-b5)/(a5-b5);
    Test_data.Origin(i) = (Test_data.Origin(i)-b6)/(a6-b6);
end
clear a a1 a2 a3 a4 a5 a6 b b1 b2 b3 b4 b5 b6

%% Computacion de los pesos y resultados (2da permutación)
Train_features2 = [Training_data.Weight,Training_data.Displacement,Training_data.Horsepower,Training_data.cylinders,Training_data.Acceleration,Training_data.Model,Training_data.Origin];
Test_features2 = [Test_data.Weight,Test_data.Displacement,Test_data.Horsepower,Test_data.cylinders,Test_data.Acceleration,Test_data.Model,Test_data.Origin];

j = 1;
for i=2:+1:numel(Train_Pred2-1)
    [Resultados_Train,Pesos_Train] = weight(Train_features2(1:i,:),Train_Pred2(1:i));
    Error_Entrenamiento(j,1) =  mean((Train_Pred2(1:i)-Resultados_Train).^2);
    D1 = ones(numel(Test_Pred2),1);
    D1 = [D1,Test_features2];
    Resultados_Test = D1*Pesos_Train;
    Error_Test(j,1) = mean((Test_Pred2-Resultados_Test).^2);
    j = j+1;
end
%% Curvas de aprendizaje (2da permutación)
% Nota:
%
% Hay un dato mas de entrenamiento que de test, debido a que el valor de
% test practicamente dobla el error de entrenamiento, sin embargo se puede
% apreciar el comportamiento
figure
plot(Error_Entrenamiento(8:26))
hold on
plot(Error_Test(8:26))
hold off
xlabel('Cantidad de muestras')
ylabel('Porcentaje de error')
title('Curva de aprendizaje')
legend('Entrenamiento','Test')
%% kNN (2da permutación)
k = 1;
a = 1;
for j=1:+5:numel(Train_Pred2)
    Train_features = [Training_data.Weight(1:j),Training_data.Displacement(1:j),Training_data.Horsepower(1:j),Training_data.cylinders(1:j),Training_data.Acceleration(1:j),Training_data.Model(1:j),Training_data.Origin(1:j)];
        for i=1:+1:numel(Test_Pred2)
            Distancia = sum(abs(Train_features-Test_features2(i,:)),2);
            Mat = [Distancia,Train_Pred2(1:j)];
            Mat = sortrows(Mat,1);
            Sol(i,1) = mean(Mat(1:k,2));
        end
        Error_kNN(a,1) = mean((Test_Pred2(i)-Sol(i)).^2);
        a = a+1;
end
%% Curva de aprendizaje para el kNN
plot(Error_kNN)
xlabel('Cantidad de muestras')
ylabel('% de aciertos')
title('Curva de aprendizaje')

%% Análisis y conclusión
% Observamos que ambos algoritmos se comportan de manera similar, a medida
% que obtienen mas informacion, comienzan a tener mejor y mejor desempeño,
% también podemos notar que los resultados son bastante similares para
% ambas permutaciones y que ambos algoritmos cumplen con lo requerido de
% manera correcta, sin embargo debido a la simplicidad de ejecución del
% modelo, el tamaño necesario para implementar, etc, entendemos que es
% mucho más eficiente el utilizar el modelo de regresión.

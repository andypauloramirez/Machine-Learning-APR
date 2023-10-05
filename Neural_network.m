%%  Red Neuronal:

% Implementar el algoritmo planteado por  Alpaydin para backpropagation  
% usando su propio código (no uso de librerías)  para implementar una red 
% neuronal que aplique  la  clasificación sobre la base que hemos estado 
% utilizando (estimar "cardio" en la base de cardiovascular).


clear; clc;

%% Agregar valores de dataset

Set_datos  = xlsread('cardio_train.xlsx','A2:M70001');

%{'Age','Height','Weight','Ap_hi','Ap_lo','Cardio'};  % Features utilizados donde solo escojimos los valores continuos
Set_datos  = Set_datos(:,[2,4,5,6,7,13]);             % Seleccion de Columnas que contienen los features a implementar
[L,~]      = size(Set_datos);                         % Cantidad de valores de prueba 
Set_datos  = Set_datos(randperm(L),:);                % Aleatorizacion de la data

%% Normalización

% Valores_max = max(Set_datos);                             
% Valores_min = min(Set_datos);
% Factor = 1./(Valores_max-Valores_min);
% Set_datos= (Set_datos - Valores_min).*Factor ;

% NOTA: Primer metodo de normalizacion de los datos, no utilizado porque amplificaba ruido

Set_datos(:,1:end-1) = (Set_datos(:,1:end-1)-mean(Set_datos(:,1:end-1)))./std(Set_datos(:,1:end-1));     % Normalizacion de datos a traves de media y Desv estandar
Set_datos            = [ones(L,1) Set_datos];                                                            % Añadir Bias Input

%% Separacion de datos

Rango       = randperm(length(Set_datos));
Para_Train  = Rango(1:round(0.75*length(Set_datos)));                                                    % 75% de valores para Train
Para_Test   = Rango(round(0.75*length(Set_datos))+1:end);                                                % 25% de valores para Test
clear Rango                                                                                              % Limpiamos la variable Rango porque ya no es utilizada nuevamente
%{Bias Age Height Weight Ap_hi Ap_lo Cardio}; 
Train       = Set_datos(Para_Train,:);                                                                   % Almacenamos en la variable Train los valores de entrenamiento                                                                       
Test        = Set_datos(Para_Test,:);                                                                    % Almacenamos en la variable Test los valores de prueba

%% Inicializacion de red

Inputs        = 5;                                                                                       % Cantidad de features implementados
Hidden_layers = 3;                                                                                       % Elegido arbitrariamnete
n             = 0.01;                                                                                    % Learning factor tomado arbitrariamente debe de estar entre (0 y 1)
Bias          = 1;

W             = normrnd(0,0.006,[Inputs+1,Hidden_layers]);                                               % Creacion de los pesos aleatorios para cada input
W_hidden      = normrnd(0,0.006,[Hidden_layers+1,1]);                                                    % Creacion de los pesos para los hidden layers

%% Aplicacion de red

epoch = 200;                                                                        % Cantidad de repeticiones al dataset
[L,~] = size(Train);                                                                % Cantidad de valores de prueba                                                                                  

for x=1:1:epoch                                                                     % Bucle
    
  for i = 1:1:L                                                                                      
                    % FORWARD PROPAGATION
    
      Hidden_Units          = Train(i,1:end-1)*W;                         % Encontramos los hidden units 
      Hidden_Units          = [Bias 1./(1+exp(-(Hidden_Units)))];         % Activacion de los hidden units con la funcion sigmoide y agregar BIAS
      
      Output_sin_actv       = Hidden_Units*W_hidden;                      % Encontramos la salida
      Output                = 1./(1+exp(-(Output_sin_actv)));             % "Activamos" la salida, que nos ofrece la probabilidad de que pertenezca a una clase u otra
     
                    % BACK PROPAGATION
    
      Error(i,x)            = -((Train(i,end)*log(Output)) + ((1-Train(i,end))*log(1-Output)));          % Calculamos el error
      update_pesos_hidden   = n*((Train(i,end)-Output).*Hidden_Units');                                  % Update pesos
      update_pesos          = n* Train(i,1:end-1)' * ( (Train(i,end)-Output) * W_hidden(2:end,1)' .* Hidden_Units(1,2:end) .* (1-Hidden_Units (1,2:end)) ) ;
      
      W_hidden              = W_hidden + update_pesos_hidden;                                            % Asignacion de nuevo valor de W_hidden       
      W                     = W + update_pesos;                                                          % Asignacion de nuevo valor de W
  end 
end 

W                                                                                                        % Presentacion de W final
W_hidden                                                                                                 % Presentacion de W_hidden final

%% Comprobar rendimiento con Test

[L,~] = size(Test); 
for i=1:1:L   
    
    Hidden_Units = Test(i,1:end-1)*W;
    Hidden_Units = [1 1./(1+exp(-(Hidden_Units)))];
      
    Output_sin_actv = Hidden_Units*W_hidden;
    Salida(i,1) = 1./(1+exp(-(Output_sin_actv)));
    
end 
    
    Error = mean(Error);                                                                                 % Error promedio de loas estimaciones de cada epoch
    X= 1:1:epoch;                                                                                        % Vector Epoch para la grafica
   
    plot(X,Error)
    grid on
    title  ('Error por Epoch')
    xlabel ('Epoch')
    ylabel ('Error')
    
    Results = round(Salida);
    aciertos = (mean(Results == Test(:,end)))*100                                                        % Funcion para calculo de aciertos   
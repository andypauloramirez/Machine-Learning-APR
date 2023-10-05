

%% Inicio

% Limpiar
clear
clc

% Importación de los valores a usar
Dataset ='cardio_train.xlsx';

% Banco de información 
edadT  = readtable ('cardio_train.xlsx','sheet','cardio_train','Range','A2:A70001');
alturaT  = readtable ('cardio_train.xlsx','sheet','cardio_train','Range','B2:B70001');
pesoT  = readtable ('cardio_train.xlsx','sheet','cardio_train','Range','C2:C70001');
enfermoT = readtable ('cardio_train.xlsx','sheet','cardio_train','Range','D2:D70001');

% Parámetros de tabla convertidos a formato matriz
edad  =table2array  (edadT);
altura  = table2array (alturaT);
peso = table2array (pesoT);
enfermo  = table2array (enfermoT);

% Agrupando en una tabla los parámetros
Tabla = [edad altura peso enfermo];

% Parametro de control
nbins = 50;
longitud = numel(edad);
Tabla = Tabla(randperm(longitud),:);    % Aleatorización del arreglo

%% Parte 1
tic
%//////////////////////////Operaciones Probabilísticas Básicas/////////////
Media = mean(Tabla(:,2:3));                                                                         % Media de los valores de peso y altura
Dis_Estandar = std (Tabla(:,2:3));                                                                  % Desviación estándar de los valores de peso y altura
Covarianza = (transpose(Tabla(:,2:3)-Media)*(Tabla(:,2:3)-Media))./(longitud-1);                    % Covarianza de los valores de peso y altura
Correlacion = Covarianza/(Dis_Estandar(1,1)*Dis_Estandar(1,2));                                     % Correlación de los valores de peso y altura

%//////////////////////////Discriminando///////////////////////////
[f,~] = find (Tabla(:,4)>0);
[f2,~] = find (Tabla(:,4)<1);
Features_enfermos = Tabla(f,2:3);
Features_sanos = Tabla(f2,2:3);

%//////////////////////////////Enfermos////////////////////////////////////
Media_enfermos = mean (Features_enfermos);
Covarianza_enfermos = (transpose(Features_enfermos-Media_enfermos)*(Features_enfermos-Media_enfermos))./(numel(Features_enfermos(:,1))-1);

%////////////////////////////////Sanos/////////////////////////////////////
Media_sanos = mean (Features_sanos);
Covarianza_sanos = (transpose(Features_sanos-Media_sanos)*(Features_sanos-Media_sanos))./(numel(Features_sanos(:,1))-1);

%///////////////////////////////Gráficas//////////////////////////////

% ////////////////////////Enfermos//////////////////////////

% [X1,X2] = meshgrid(Features_enfermos(:,1)',Features_enfermos(:,2)');
% X = [X1(:) X2(:)];
% Z = mvnpdf(X,Media_enfermos,Covarianza_enfermos);
% Z = reshape(Z,length(Features_enfermos(:,2)),length(Features_enfermos(:,1)));
% % figure
% surf(Features_enfermos(:,1)',Features_enfermos(:,2)',Z)
% xlabel ('Altura')
% ylabel ('Peso')
% zlabel ('Probabilidad de Enfermos')
% title ('Gráfica de Probabilidad de Enfermos')

% figure
% Histograma = [Features_enfermos(:,1), Features_enfermos(:,2)];
% hist3 (Histograma)
% xlabel ('Altura')
% ylabel ('Peso')
% zlabel ('Cantidad de Personas')
% title ('Histograma de Cantidad de Enfermos')

% //////////////////////////Sanos///////////////////////////

% [X1,X2] = meshgrid(Features_sanos(:,1)',Features_sanos(:,2)');
% X = [X1(:) X2(:)];
% Z = mvnpdf(X,Media_sanos,Covarianza_sanos);
% Z = reshape(Z,length(Features_sanos(:,2)),length(Features_sanos(:,1)));
% % figure
% surf(Features_sanos(:,1)',Features_sanos(:,2)',Z)
% xlabel ('Altura')
% ylabel ('Peso')
% zlabel ('Probabilidad de Sanos')
% title ('Gráfica de Probabilidad de Sanos')

% figure
% Histograma = [Features_sanos(:,1), Features_sanos(:,2)];
% hist3 (Histograma)
% xlabel ('Altura')
% ylabel ('Peso')
% zlabel ('Cantidad de Personas')
% title ('Histograma de Cantidad de Sanos')

%//////////////////////////////////////////////////////////////////////////

%/////////////Cálculo de Distribución Estándar y Normal////////////////////
Dis_Estandar = std (Features_enfermos);
Dist_Norm1 = normrnd (Media(1,1),Dis_Estandar(1,1),[longitud,1]);
Dist_Norm2 = normrnd (Media(1,2),Dis_Estandar(1,2),[longitud,1]);

Dis_Estandar2 = std (Features_sanos);
Dist_Norm3 = normrnd (Media_sanos(1,1),Dis_Estandar2(1,1),[longitud,1]);
Dist_Norm4 = normrnd (Media_sanos(1,2),Dis_Estandar2(1,2),[longitud,1]);

%/////////////////////////////Priors/////////////////////////////////////////////////
prior = numel(Features_enfermos(:,1))/longitud; % Enfermos
prior2 = numel(Features_sanos(:,1))/longitud;   % Sanos

%/////////////////Variables para calculo de probabilidad///////////////////
Si = (transpose(Features_enfermos-Media_enfermos)*(Features_enfermos-Media_enfermos))/(numel(Features_enfermos(:,1)));
MatrizW1=-0.5*inv(Si);
El_wi=Media_enfermos*inv(Si);
El_Wio=-0.5*Media_enfermos*inv(Si)*transpose(Media_enfermos)-0.5*log(det(Si))+log(prior);


Si2 = (transpose(Features_sanos-Media_sanos)*(Features_sanos-Media_sanos))/(numel(Features_sanos(:,1)));
MatrizW2=-0.5*inv(Si2);
El_wi2=Media_sanos*inv(Si2);
El_Wio2=-0.5*Media_sanos*inv(Si2)*transpose(Media_sanos)-0.5*log(det(Si2))+log(prior2);

%////////Probabilidad para discriminacion//////////////////////////////////

for i=1:1:longitud
Probabilidad_enfermo(i,1) = Tabla(i,2:3)*MatrizW1*transpose(Tabla(i,2:3)) + Tabla(i,2:3)*transpose(El_wi) + El_Wio;
end

for i=1:1:longitud
Probabilidad_sanos(i,1) = Tabla(i,2:3)*MatrizW2*transpose(Tabla(i,2:3)) + Tabla(i,2:3)*transpose(El_wi2) + El_Wio2;
end

%////////////////////////////Predicción////////////////////////////////////
for i = 1:1:longitud
    if Probabilidad_enfermo(i,1) < Probabilidad_sanos(i,1)
        Estimado(i,1)=0;
    else
        Estimado(i,1)=1;
    end
end

%/////////////////////////Porcentaje de Aciertos///////////////////////////
aciertos = mean(Estimado == Tabla(:,4))
toc
%% Parte 2
tic
%/////////////////////////////Discriminación de Datos//////////////////////
[f,c] = find (Tabla(:,4)>0);
[f2,c2] = find (Tabla(:,4)<1);

%////Cálculo de Medias y Desviaciones Estandar por Característica//////////

% Edad
M = [Tabla(f,1)];      %Vector que almacena a los enfermos
M2 = Tabla(f2,1);      %Vector que almacena a los sanos

Media = mean (M);
Dis_Estandar = std (M);

Media_2 = mean (M2);
Dis_Estandar_2 = std (M2);

% Altura
M3 = [Tabla(f,2)];      %Vector que almacena a los enfermos
M4 = Tabla(f2,2);      %Vector que almacena a los sanos

Media_3 = mean (M3);
Dis_Estandar_3 = std (M3);

Media_4 = mean (M4);
Dis_Estandar_4 = std (M4);

% Peso
M5 = [Tabla(f,3)];      %Vector que almacena a los enfermos
M6 = Tabla(f2,3);      %Vector que almacena a los sanos

Media_5 = mean (M5);
Dis_Estandar_5 = std (M5);

Media_6 = mean (M6);
Dis_Estandar_6 = std (M6);

%////////////////Probabilidades de Enfermos por Característica/////////////
Funcion_enfermos_Edad = (1/(Dis_Estandar*sqrt(2*pi^3)))*exp(-((edad-Media).^2)/(2*(Dis_Estandar^2)));
Funcion_enfermos_Altura = (1/(Dis_Estandar_3*sqrt(2*pi^3)))*exp(-((altura-Media_3).^2)/(2*(Dis_Estandar_3^2)));
Funcion_enfermos_Peso = (1/(Dis_Estandar_5*sqrt(2*pi^3)))*exp(-((peso-Media_5).^2)/(2*(Dis_Estandar_5^2)));
[Cant_enfermos,~] =size(M);
Prob_enfermo = Cant_enfermos/longitud;                                      % Prior

%////////////////////////////////////Probabilidad de Enfermos//////////////
for i = 1:1:longitud
    Prob_enfermo_Con_Todo(i,1) =log(Prob_enfermo*Funcion_enfermos_Edad(i,1)*Funcion_enfermos_Altura(i,1)*Funcion_enfermos_Peso(i,1));
end

%/////////////////Probabilidades de Sanos por Característica///////////////
Funcion_sanos_Edad = (1/(Dis_Estandar_2*sqrt(2*pi^3)))*exp(-((edad-Media_2).^2)/(2*(Dis_Estandar_2^2)));
Funcion_sanos_Altura = (1/(Dis_Estandar_4*sqrt(2*pi^3)))*exp(-((altura-Media_4).^2)/(2*(Dis_Estandar_4^2)));
Funcion_sanos_Peso = (1/(Dis_Estandar_6*sqrt(2*pi^3)))*exp(-((peso-Media_6).^2)/(2*(Dis_Estandar_6^2)));
[Cant_sano,~] = size(M2);
Prob_sano = Cant_sano/longitud;                                             % Prior

%////////////////////////////////////Probabilidad de Sanos/////////////////
for i = 1:1:longitud 
    Prob_sano_Con_Todo(i,1) =log(Prob_sano*Funcion_sanos_Edad(i,1)*Funcion_sanos_Altura(i,1)*Funcion_sanos_Peso(i,1));
end

%//////////////////////////////////Predicción//////////////////////////////
for i = 1:1:longitud
    if Prob_enfermo_Con_Todo(i,1) < Prob_sano_Con_Todo(i,1)
        Estimado(i,1)=0;
    else
        Estimado(i,1)=1;
    end
end

%/////////////////////////Porcentaje de Aciertos///////////////////////////
aciertos = mean(Estimado == Tabla(:,4))
toc
%% Parte 3
tic
%/////////////////////////////Discriminación de Datos//////////////////////
[f,~] = find (Tabla(:,4)>0);
[f2,~] = find (Tabla(:,4)<1);
Features_enfermos = Tabla(f,1:3);
Features_sanos = Tabla(f2,1:3);

%////////////////////////////Media de Clases///////////////////////////////
Media_enfermos = mean (Features_enfermos);
Media_sanos = mean (Features_sanos);

%/////////////////////////////Priors/////////////////////////////////////////////////
prior = numel(Features_enfermos(:,1))/longitud;
prior2 = numel(Features_sanos(:,1))/longitud;

%/////////////////Variables para cálculo de probabilidad///////////////////
Si = (transpose(Features_enfermos-Media_enfermos)*(Features_enfermos-Media_enfermos))/(numel(Features_enfermos(:,1)));
MatrizW1=-0.5*inv(Si);
El_wi=Media_enfermos*inv(Si);
El_Wio=-0.5*Media_enfermos*inv(Si)*transpose(Media_enfermos)-0.5*log(det(Si))+log(prior);


Si2 = (transpose(Features_sanos-Media_sanos)*(Features_sanos-Media_sanos))/(numel(Features_sanos(:,1)));
MatrizW2=-0.5*inv(Si2);
El_wi2=Media_sanos*inv(Si2);
El_Wio2=-0.5*Media_sanos*inv(Si2)*transpose(Media_sanos)-0.5*log(det(Si2))+log(prior2);

%////////////////////////////////////Probabilidad de Enfermos//////////////
for i=1:1:longitud
Probabilidad_enfermo(i,1) = Tabla(i,1:3)*MatrizW1*transpose(Tabla(i,1:3)) + Tabla(i,1:3)*transpose(El_wi) + El_Wio;
end

%////////////////////////////////////Probabilidad de Sanos/////////////////
for i=1:1:longitud
Probabilidad_sanos(i,1) = Tabla(i,1:3)*MatrizW2*transpose(Tabla(i,1:3)) + Tabla(i,1:3)*transpose(El_wi2) + El_Wio2;
end

%//////////////////////////////////Predicción//////////////////////////////
for i = 1:1:longitud
    if Probabilidad_enfermo(i,1) < Probabilidad_sanos(i,1)
        Estimado(i,1)=0;
    else
        Estimado(i,1)=1;
    end
end

%/////////////////////////Porcentaje de Aciertos///////////////////////////
aciertos = mean(Estimado == Tabla(:,4))
toc
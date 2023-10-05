%% LDA y Neuralnet para extracción de features que representen las clases

% Usarán como target el "nivel de cholesterol" y como features aplicarán 
% todos los otros datos a excepción de "cardio". Van a aplicar LDA y con 
% éste obtendrán un cantidad reducida de features. Como recordatorio: LDA 
% reduce a máximo K-1 features, donde K es la cantidad de clases. 

% Por otro lado, aplicarán una red neuronal para reducir la cantidad de 
% features a la misma cantidad que redujeron usando LDA. Para esto, 
% colocarán como target el mismo que usaron con LDA y en el hidden layer 
% central pondrán tantos nodos como la cantidad a la que se redujo la 
% dimensión con LDA. 

% Incluyan en sus análisis la comparación entre los resultados de hacer 
% clasificación con los features resultantes de uno y el otro 
% procedimiento, así como su opinión acerca de los procesos mismos.



clear; clc;

%% Dataset

% Se presenta la base de datos de cardio general:
CardioGeneral = readtable('Cardio_Training_Simplificado.csv');
Cardio        = table2array(CardioGeneral(:,1:end-1));

% Recordando que en este se estan evaluando los siguientes features:
    % Columna 1:  Edad (días)
    % Columna 2:  Género (1 = mujer | 2 = hombre)
    % Columna 3:  Tamaño (cm)
    % Columna 4:  Peso (kg)
    % Columna 5:  Presión de sangre sistólica
    % Columna 6:  Presión de sangre diastólica
    % Columna 7:  Actividad física                       (0 = no | 1 = sí)
    % Columna 8:  Glucosa (1 = normal | 2 = alta | 3 = muy alta)
    % Columna 9:  Fumar                                  (0 = no | 1 = sí)
    % Columna 10: Alcohol intake                         (0 = no | 1 = sí)
    % Columna 11: Colesterol (1 = normal | 2 = alta | 3 = muy alta)

% OJO: Este excel no es el mismo que el presentado en la página ya que
% decidimos pasar a la ultima columna el colesterol y directamente eliminar
% la sección de id y cardio.
    
% En total se tiene un dataset para 70,000 pacientes. Considerando que se 
% pueda tener algún dato de cualquiera de estos pacientes vacío, 
% procedemos a llenar este por un 2:
Cardio = Cardio(~any(ismissing(Cardio),2),:);

% Presentamos el target:
Target = Cardio(:,end); % Recordando que este representa el colesterol

% Una vez hecho esto, separamos la data entre cada categoría de colesterol,
% haciendo un total de 3:
Col1 = Cardio(Cardio(:,end) == 1,:); % Normal
Col2 = Cardio(Cardio(:,end) == 2,:); % Alta
Col3 = Cardio(Cardio(:,end) == 3,:); % Muy Alta

% Recordando que este fue evaluado en la última columna (8), teniendo una
% lógica trinaria.

% Luego calculamos la media y covarianza de cada feature, exceptuando la 
% columna 11 de colesterol, para cada categoria i:
MediaCol1 = sum(Col1(:,1:end-1))/length(Col1);
MediaCol2 = sum(Col2(:,1:end-1))/length(Col3);
MediaCol3 = sum(Col3(:,1:end-1))/length(Col3);

% Esto será utilizado más adelante para el cálculo de la clase Sw y la
% matríz Sb

%% Matríz de Dispersión intraclase Sw

% Se crea un S vacío al cual se le añadirán los valores en el bucle for 
% para cada categoría i:
s11 = zeros(1); % Categoria normal 
s21 = zeros(1); % Categoria alta
s31 = zeros(1); % Categoria muy alta

% Se inicializa un bucle por variable x, el cual variará de 1 hasta el
% tamaño del dataset, en nuestro caso 70,000 pacientes:
for x = 1:size(Cardio,1)
    
    % Se calcula la matriz de dispersión Si de cada categoria i: 
    
            % COLESTEROL NORMAL
    Si1Resta  = Cardio(x,1:end-1) - MediaCol1;
    Si1       = (Si1Resta)'*(Si1Resta);
    s11       = Si1 + s11;
    
            % COLESTEROL ALTO
    Si2Resta  = Cardio(x,1:end-1) - MediaCol2;
    Si2       = (Si2Resta)'*(Si2Resta);
    s21       = Si2 + s21;
    
            % COLESTEROL MUY ALTO
    Si3Resta  = Cardio(x,1:end-1) - MediaCol3;
    Si3       = (Si3Resta)'*(Si3Resta);
    s31       = Si3 + s31;
        
end

% Por último se suman para obtener la matriz de dispersión intraclase Sw:
Sw = s11 + s21 + s31;

%% Matriz de Dispersión entre clases Sb

% Empezamos creando tres variables N, los cuales representarán la cantidad
% de casos para cada categoría:

N1 = size(Col1,1); % Número de pacientes con colesterol normal 
N2 = size(Col2,1); % Número de pacientes con colesterol alto
N3 = size(Col3,1); % Número de pacientes con colesterol muy alto

% Luego, calculamos la media total entre cada categoría, de tal manera
% que este sea llamado en el bucle for de Sb:
MediaTotal = (MediaCol1(1,1:end) + MediaCol2(1,1:end) + MediaCol3(1,1:end))./3;

% Al igual que como se realizó para Sw, se crea un S vacío al cual se le 
% añadirán los valores en el bucle for para cada categoría i:
s12 = zeros(1); % Categoria normal 
s22 = zeros(1); % Categoria alta
s32 = zeros(1); % Categoria muy alta

% Se inicializa un bucle por variable x, el cual variará de 1 hasta el
% tamaño de cada categoría i:

            % COLESTEROL NORMAL
for x = 1:N1
    % Se calcula la matriz de dispersión Sb: 
    Sb1Resta   = MediaCol1 - MediaTotal;
    Sb11       = (N1*(Sb1Resta)'.*(Sb1Resta));
    % Se le añade este resultado a la variable vacia s12
    s12        = Sb11 + s12;
end

            % COLESTEROL ALTO
for x = 1:N2
    % Se calcula la matriz de dispersión Sb:
    Sb2Resta   = MediaCol2 - MediaTotal;
    Sb12       = (N2*(Sb2Resta)'.*(Sb2Resta));
    % Se le añade este resultado a la variable vacia s12
    s22        = Sb12 + s22;
end

            % COLESTEROL MUY ALTO
for x = 1:N3
    % Se calcula la matriz de dispersión Sb:
    Sb3Resta   = MediaCol3 - MediaTotal;
    Sb13       = (N3*(Sb3Resta)'.*(Sb3Resta));
    % Se le añade este resultado a la variable vacia s12
    s32        = Sb13 + s32;
end

% Por último se suman para obtener la matriz de dispersión entre clases Sb:
Sb = s12 + s22 + s32;

%% LDA 

Clases = 3;

% Se resuelve para Sw^(-1)*Sb:
[eigen_vecs,eigen_vals]  = eig(inv(Sw).*Sb);
eigen_vals               = sum(eigen_vals);

for i=1:1:Clases-1
    [~,Indice]           = max(eigen_vals);
    W(:,i)               = abs(eigen_vecs(:,Indice));
    eigen_vals(:,Indice) = -1e50;
end

% Se toma el valor absoluto de los dos últimos números resultantes
% considerando estos como los más significativos dentro de los Eigen 
% Vectors. Este será entonces implementado para el nuevo dataset con 
% reducción (K-1):


% Se presenta el nuevo dataset considerando todos los features menos 
% cardio, teniendo como target entonces el colesterol:
ResultadoLDA = [Cardio(:,1:end-1)*W Target];

%% Train y Test

% Una vez creado el dataset reducido, pasamos entonces a dividirlo entre
% train y test.

% Para esto aprovecharemos la función de randperm, el cual nos permitirá
% poder seleccionar de manera aleatoria el dataset de entrenamiento (75%) 
% y de prueba (25%).
Rand = randperm(size(ResultadoLDA,1));

% Este variando entonces para los 70,000 pacientes del nuevo dataset
Train = ResultadoLDA (Rand(0.25*size(ResultadoLDA,1)+1:end ),:); % 52,500 (75% de los datos)
Test  = ResultadoLDA (Rand(1:size(ResultadoLDA   ,1)*0.25  ),:); % 17,500 (25% de los datos)

% Tomando ahora el Train como base de estudio, implementaremos el método de
% Bayes, separando primero este en cada categoría:
Col_normal   = Train(Train(:,end) == 1,:); % Colesterol normal en train 
Col_alto     = Train(Train(:,end) == 2,:); % Colesterol alto en train
Col_muy_alto = Train(Train(:,end) == 3,:); % Colesterol muy alto en train


% Hecho esto, podemos observar que de los 52,500 pacientes del train:
    % Aproximadamente 39,000 tienen el colesterol normal, 7,000 tienen el 
    % colesterol alto y 6,000 tienen el colesterol muy alto. Estos valores
    % varían en cada corrida debido a la función Rand pero aproximan a 
    % estos valores en los miles.

%% Cálculos Estadísticos

% Para el cálculo de los posteriores y la predicción, es necesario entonces
% plantear el uso de la media, desviación estandar y prior de cada
% categoria i, recordando que en este caso estamos planteando para
% colesterol, por lo que tendremos 3:

                    % Feature 1
        
                % MEDIA
MediaCol1_f1    = mean(Col_normal(:,1));    % Media de colesterol normal
MediaCol2_f1    = mean(Col_alto(:,1));      % Media de colesterol alto
MediaCol3_f1    = mean(Col_muy_alto(:,1));  % Media de colesterol muy alto
            
            % DESVIACIÓN ESTÁNDAR
DesTrainCol1_f1 = std(Col_normal(:,1));     % Desviación estándar de colesterol normal
DesTrainCol2_f1 = std(Col_alto(:,1));       % Desviación estándar de colesterol alto
DesTrainCol3_f1 = std(Col_muy_alto(:,1));   % Desviación estándar de colesterol muy alto

                    % Feature 2
        
                % MEDIA
MediaCol1_f2    = mean(Col_normal(:,2));    % Media de colesterol normal
MediaCol2_f2    = mean(Col_alto(:,2));      % Media de colesterol alto
MediaCol3_f2    = mean(Col_muy_alto(:,2));  % Media de colesterol muy alto
            
            % DESVIACIÓN ESTÁNDAR
DesTrainCol1_f2 = std(Col_normal(:,2));     % Desviación estándar de colesterol normal
DesTrainCol2_f2 = std(Col_alto(:,2));       % Desviación estándar de colesterol alto
DesTrainCol3_f2 = std(Col_muy_alto(:,2));   % Desviación estándar de colesterol muy alto

            % PRIOR
PriorCol1       = size(Col_normal,1)/size(Train,1);     % Prior de colesterol normal
PriorCol2       = size(Col_alto,1)/size(Train,1);       % Prior de colesterol alto
PriorCol3       = size(Col_muy_alto,1)/size(Train,1);   % Prior de colesterol muy alto

%% Posteriors

% Para esto empezamos calculando la densidad de probabilidad gaussiana para
% cada categoría i (en nuestro caso, al nuestro target ser el colesterol 
% tenemos 3 categorias):

                            % Densidad f1
Densidadf1_1 = (1 / (sqrt(2 * pi * DesTrainCol1_f1))) * exp(-((Test(:,1)- MediaCol1_f1).^2 / (2 * DesTrainCol1_f1^2)));
Densidadf1_2 = (1 / (sqrt(2 * pi * DesTrainCol2_f1))) * exp(-((Test(:,1)- MediaCol2_f1).^2 / (2 * DesTrainCol2_f1^2)));
Densidadf1_3 = (1 / (sqrt(2 * pi * DesTrainCol3_f1))) * exp(-((Test(:,1)- MediaCol3_f1).^2 / (2 * DesTrainCol3_f1^2)));

                            % Densidad f2
Densidadf2_1 = (1 / (sqrt(2 * pi * DesTrainCol1_f2))) * exp(-((Test(:,1)- MediaCol1_f2).^2 / (2 * DesTrainCol1_f2^2)));
Densidadf2_2 = (1 / (sqrt(2 * pi * DesTrainCol2_f2))) * exp(-((Test(:,1)- MediaCol2_f2).^2 / (2 * DesTrainCol2_f2^2)));
Densidadf2_3 = (1 / (sqrt(2 * pi * DesTrainCol3_f2))) * exp(-((Test(:,1)- MediaCol3_f2).^2 / (2 * DesTrainCol3_f2^2)));

% Hecho esto, multiplicamos la densidad de cada categoria i por su prior
% correspondiente:
Posterior_Normal  = log( (Densidadf1_1.*Densidadf2_1) * PriorCol1);
Posterior_Alto    = log( (Densidadf1_2.*Densidadf2_2) * PriorCol2);
Posterior_MuyAlto = log( (Densidadf1_3.*Densidadf2_3) * PriorCol3);

% Creamos un bucle for de variable x, que varie para toda variable dentro
% de los posterior... obteniendo así las predicciones del target, en
% nuestro caso colesterol. En este entonces se tiene como condición que
% posterior1 debe ser mayor a posterior2 que debe ser mayor a posterior3,
% esto para garantizar que el colesterol del dataset este siendo
% debidamente clasificado en su categoria 1, 2 y 3.

for x = 1:1:size(Test,1)
    if Posterior_Normal(x,1) > Posterior_Alto(x,1) && Posterior_Normal(x,1) > Posterior_MuyAlto(x,1)
        Prediccion(x,1) = 1;
    
    elseif Posterior_Alto(x,1) > Posterior_Normal(x,1) && Posterior_Alto(x,1) > Posterior_MuyAlto(x,1)
        Prediccion(x,1) = 2;
        
    else
        Prediccion(x,1) = 3;
    end
end


% Una vez hecho esto, calculamos el porcentaje de aciertos del nuevo
% dataset:
Acierto = (mean(Test(:,end) == Prediccion(1)))*100


%% Red Neuronal

% Para la parte de red neuronal, aplicamos nntool en el Command Windows

Input  = Cardio(:,1:end-1)';
Target = Cardio(:,11)';

% RN_LDA_outputs = RN_LDA_outputs';
% RN_LDA_errors  = RN_LDA_errors';
% save('Output.mat','RN_LDA_outputs')
% save('Errors.mat','RN_LDA_errors')

% OJO: Las líneas de arriba estan comentadas porque ya obtuvimos los
% archivos anteriormente, los cuales se encuentran adjuntos en la carpeta
% de entrega.

load ('Output.mat')
load ('Errors.mat')

RN_LDA_outputs = RN_LDA_outputs';

Aciertos_RedNeuronal = (mean(Test(:,end) == Prediccion(1)))*100
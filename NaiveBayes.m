

% ----------------------------- Data set ----------------------------------
BI_dataTest = xlsread('test.xlsx');
BI_test = readtable('test.xlsx');
BI_dataTrain = xlsread('train.xlsx');
BI_train = readtable('train.xlsx');

%-------- Delete missing values of embarked information -------------------
% Eliminar datos vacios
BI_train = BI_train(~any(ismissing(BI_train{:,12}),2),:);    
BI_train = BI_train(~any(ismissing(BI_train{:,10}),2),:);

%---------------- Random permutation of data ------------------------------
Shuffle_testData = BI_test(randperm(size(BI_test,1)),:);
Shuffle_trainData = BI_train(randperm(size(BI_train,1)),:);

%--------------------- Categorical data -----------------------------------
Shuffle_testData.Sex = categorical(Shuffle_testData.Sex);
Shuffle_testData.Pclass = categorical(Shuffle_testData.Pclass);
Shuffle_testData.Embarked = categorical(Shuffle_testData.Embarked);

Shuffle_trainData.Sex = categorical(Shuffle_trainData.Sex);
Shuffle_trainData.Pclass = categorical(Shuffle_trainData.Pclass);
Shuffle_trainData.Embarked = categorical(Shuffle_trainData.Embarked);

% --------------- Convertir de tabla a arreglo ----------------------------
% Numerico
NB_test_num = table2array(Shuffle_testData(:,[5 6 7 9 12]));
NB_train_num = table2array(Shuffle_trainData(:,[2 6 7 8 10]));

% Categorica
NB_test_cat = table2array(Shuffle_testData(:,[2 4 11]));
NB_train_cat = table2array(Shuffle_trainData(:,[3 5 12]));

%----------------- Estimation of missing values ---------------------------
Age_testData = NB_test_num(:,1);
Age_trainData = NB_train_num(:,2);

% Obtener media de datos diferentes de NaN
MV_testData = nanmean(Age_testData);                   
MV_trainData = nanmean(Age_trainData);

% Sustituir los valores vacios por la media
Age_testData(isnan(Age_testData)) = round(MV_testData);     
Age_trainData(isnan(Age_trainData)) = round(MV_trainData);

NB_test_num(:,1) = Age_testData;
NB_train_num(:,2) = Age_trainData;

% ------------------------- Data a utilizar -------------------------------
% Numerica
% Age SibSp Parch Fare
Survived_train_num = NB_train_num(NB_train_num(:,1)==1,[2 3 4 5]);
Deceased_train_num = NB_train_num(NB_train_num(:,1)==0,[2 3 4 5]);

% Categorica
% Pclass sex embarked
SurvivedC_Train = Shuffle_trainData(Shuffle_trainData{:,2}==1,[3 5 12]);
DeceasedC_Train = Shuffle_trainData(Shuffle_trainData{:,2}==0,[3 5 12]);
Survived_train_cat = table2array(SurvivedC_Train);
Deceased_train_cat = table2array(DeceasedC_Train);

% Valor del prior
Prior_survived = mean(NB_train_num(:,1));
Prior_deceased = 1 - mean(NB_train_num(:,1));

% --------------------- Probabilidad datos categoricos --------------------
% probabilidad_PclassSurvived = sum(SurvivedC_train_cat == '1')./ (size(SurvivedC_train_cat,1));
% Survived
[BSclass,BGSclass,BPSclass] = groupcounts(Survived_train_cat(:,1));
BPSclass = transpose(BPSclass );
probabilidad_PclassSurvived = BPSclass./100;     %[1 2 3]

[BSsex,BGSsex,BPSsex] = groupcounts(Survived_train_cat(:,2));
BPSsex = transpose(BPSsex);
probabilidad_SexSurvived = BPSsex./100;          %[female male]

[BSembarked,BGSembarked,BPSembarked] = groupcounts(Survived_train_cat(:,3));
BPSembarked = transpose(BPSembarked);
probabilidad_EmbarkedSurvived = BPSembarked./100;%[C Q S]

% Deceased
[BDclass,BGDclass,BPDclass] = groupcounts(Deceased_train_cat(:,1));
BPDclass = transpose(BPDclass );
probabilidad_PclassDeceased = BPDclass./100;     %[1 2 3]

[BDsex,BGDsex,BPDsex] = groupcounts(Deceased_train_cat(:,2));
BPDsex = transpose(BPDsex);
probabilidad_SexDeceased = BPDsex./100;          %[female male]

[BDembarked,BGDembarked,BPDembarked] = groupcounts(Deceased_train_cat(:,3));
BPDembarked = transpose(BPDembarked);
probabilidad_EmbarkedDeceased = BPDembarked./100;%[C Q S]

% ----------------Probabilidad de datos continuos--------------------------
% medias y desviaciones estandar
mean_Survived = mean(Survived_train_num);
desv_Survived = std(Survived_train_num);
mean_Deceased = mean(Deceased_train_num);
desv_Deceased = std(Deceased_train_num);

% Calculo de probabilidad
PX = NB_test_num; 
PX(:,5)=[];
probabilidad_Survived = (1./(sqrt(2*pi)*desv_Survived)).*exp( (-(PX - mean_Survived).^2) ./ (2*(desv_Survived).^2));
probabilidad_Deceased = (1./(sqrt(2*pi)*desv_Deceased)).*exp( (-(PX- mean_Deceased).^2) ./ (2*(desv_Deceased).^2));

%--------------- Probabilidad de datos categoricos ------------------------
% Assuming survived
BGSclass = transpose(BGSclass);
val_class = BGSclass == NB_test_cat(:,1);
prob_class = val_class .* probabilidad_PclassSurvived;
vC = nonzeros(prob_class');
probSurv_class = reshape(vC,1,size(NB_test_cat,1))';

BGSsex = transpose(BGSsex);
val_sex = BGSsex == NB_test_cat(:,2);
prob_sex = val_sex .* probabilidad_SexSurvived;
vS = nonzeros(prob_sex');
probSurv_sex = reshape(vS,1,size(NB_test_cat,1))';

BGSembarked = transpose(BGSembarked);
val_embarked = BGSembarked == NB_test_cat(:,3);
prob_embarked = val_embarked .* probabilidad_EmbarkedSurvived;
vE = nonzeros(prob_embarked');
probSurv_embarked = reshape(vE,1,size(NB_test_cat,1))';

Psurvived = [probSurv_class probSurv_sex probSurv_embarked];

% Assuming Deceased
BGDclass = transpose(BGDclass);
val_class = BGDclass == NB_test_cat(:,1);
prob_class = val_class .* probabilidad_PclassDeceased;
vC = nonzeros(prob_class');
probDec_class = reshape(vC,1,size(NB_test_cat,1))';

BGDsex = transpose(BGDsex);
val_sex = BGDsex == NB_test_cat(:,2);
prob_sex = val_sex .* probabilidad_SexDeceased;
vS = nonzeros(prob_sex');
probDec_sex = reshape(vS,1,size(NB_test_cat,1))';

BGDembarked = transpose(BGDembarked);
val_embarked = BGDembarked == NB_test_cat(:,3);
prob_embarked = val_embarked .* probabilidad_EmbarkedDeceased;
vE = nonzeros(prob_embarked');
probSurv_embarked = reshape(vE,1,size(NB_test_cat,1))';

Pdeceased = [probSurv_class probSurv_sex probSurv_embarked];

% ---------------------------Prediccion----------------------------
% Probabilidad de que sobrevivio 
Survived_cat = prod(Psurvived,2);
Survived_num = prod(probabilidad_Survived,2);
pos =  [Survived_cat Survived_num];

Deceased_cat = prod(Pdeceased,2);
Deceased_num = prod(probabilidad_Deceased,2);
pod = [Deceased_cat Deceased_num];

Probability_of_Survival = (prod(pos,2)) .* Prior_survived;
Porbability_of_Demise   = (prod(pod,2)) .* Prior_deceased;

% Prediccion 
Prediccion = Probability_of_Survival>Porbability_of_Demise;
% Tasa de Aciertos
TasaDeAciertos = mean(Prediccion==NB_test_num(:,5));

% Falsos positivos
FP = nnz(NB_test_num(:,5)==0 & Prediccion==1); % False positive
TasaDeFalsosPositivos = FP/(size(NB_test_num,1));
% Falsos negativos
FN = nnz(NB_test_num(:,5)==1 & Prediccion==0); % False negative
TasaDeFalsosNegativos = FN/(size(NB_test_num,1));

%--------------------------- PRINT VALUES ---------------------------
fprintf('\nNaive Bayes:\n\n'); 
fprintf('Tasa de aciertos:\n');
fprintf('%6.5f \n\n',TasaDeAciertos);
fprintf('Tasa de falsos-positivos:\n');
fprintf('%6.5f \n\n',TasaDeFalsosPositivos);
fprintf('Tasa de falsos-negativos:\n');
fprintf('%6.5f \n\n',TasaDeFalsosNegativos);

memory
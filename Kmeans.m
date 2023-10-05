%% Laboratorio de Machine Learning: Lab 03 - K means - Andy Paulo Ramirez
close all clc
%% Asignación 1
clc
clear
% 5 fuentes de datos que generan 300 muestras bidimensionales cada una
media =(100).*rand(10,1); % vector con distribucion uniforme (0,100)
Varianza = (15).*rand(10,1);
i=1;
while i <= 10
Dataset(:,i) = normrnd(media(i,1),Varianza(i,1),[300,1]); i=i+1;
end
% Extraccion de las 5 fuentes
S1=Dataset(1:end,1:2); S2=Dataset(1:end,3:4); S3=Dataset(1:end,5:6); S4=Dataset(1:end,7:8); S5=Dataset(1:end,9:10);
% Aplicamos K_means para agrupar datos utilizando K=5
k = 5; X=Dataset(:,[1,3,5,7,9]); X=reshape(X,[1500,1]); Y=Dataset(:,[2,4,6,8,10]); Y=reshape(Y,[1500,1]); Puntos=[X,Y];
% Ploteamos los datos originales para que nos sirva de referencia
figure scatter(Puntos(:,1),Puntos(:,2),50,'red'); title('Muestras del dataset');
grid on
[f,c]=size(Puntos); % En funcion de la cantidad de datos, tomaremos muchas decisiones, por lo que lo extraemos en esta parte
a=1:1:k;
r = randi(f,1,5);
m(a,:)=Puntos(r,:); %Extraemos k muestras aleatorias, que seran nuestros centroides iniciales
% Declaracion de variable control e iteraciones
flag =0;
B=zeros(f,k);
clases (Hot****)
h=1;
iteracion = 1;
% Bandera de convergencia
% Inicialicion de variable control de
% Control de iteraciones para presentar
m_anterior = m;
evaluar su mejora
while flag == 0
while h <= f
clases en funcion de la distancia
dist=(m-Puntos(h,:)).^2; dist=sum(dist,2); [M,I]=min(dist); B(h,I)=1;
a cada puntos sus claves
h=h+1;
end
i=1; a=1;
while i<=2*k
Grupos(:,i:i+1) = B(:,a).* Puntos;
respectivo grupo
a=a+1;
i=i+c;
end
i=1;
a=1;
m=[];
% Calculamos los nuevos centroides
while i<=k*2
Num=size(find(Grupos(:,i)));
elementos estan dentro de la 'Clase x' m(a,1:c)=(sum(Grupos(:,i:i+1)))./(Num(1)); a=a+1;
i = i+c;
end
% Analisis de convergencia
dist_conv = sum((m_anterior-m).^2,2);
anterior y el recientemente calculado
este caso elegido por mi)
if size(C) == [0,1] %Esta igualda confirmaria que ya se cumplio con la restriccion de convergencia
flag = 1;
else
% Reiniciar iteradores
     i=1;
     a=1;
     h=1;
     m_anterior = m;
     B=zeros(f,k);
% Guarda centroides anteriores para
% Bucle para calcular asignacion de
% Distancia euclidiana cuadrada
% Matriz para posteriormente asignarles
% Asignacion de los puntos a su
% Para determinar cuantos %Calculo de promedio
% Comparacion entre centroide
% Para determinar si ya todos los centroides cumplen con la condición de convergencia determinada (0.1 en
C = find(dist_conv>0.1,5);

Grupos=[];
iteracion= iteracion+1;
end end
% Asignacion de clases en forma de columna
Clase=1:1:k;
clasificacion= sum(B.*Clase,2);
% Resultados obtenidos
figure scatter(Puntos(:,1),Puntos(:,2),50,clasificacion,'o'); hold on
grid on
scatter (m(:,1),m(:,2),'or','LineWidth',5) title('Clases según corrida #1');
hold off
%% Reinicio de iteradores
i=1;
a=1;
h=1;
m=[];
B=zeros(f,k); Grupos=[];
iteracion= iteracion+1;
% Repetir el clustering 3 veces, con diferentes centroides %% Segunda corrida
a=1:1:k;
r = randi(f,1,5);
m(a,:)=Puntos(r,:);
% Declaracion de variable control e iteraciones
flag =0;
B=zeros(f,k);
clases (Hot****)
h=1;
iteracion = 1;
m_anterior = m;
evaluar su mejora
while flag == 0
while h <= f dist=(m-Puntos(h,:)).^2; dist=sum(dist,2); [M,I]=min(dist); B(h,I)=1;
h=h+1;
end
i=1; a=1;
%Inicialicion de variable control de
%Control de iteraciones para presentar %Guarda centroides anteriores para

while i<=2*k
Grupos(:,i:i+1) = B(:,a).* Puntos; a=a+1;
i=i+2;
end
i=1;
a=1;
m=[];
% Calculamos los nuevos centroides
while i<=k*2
Num=size(find(Grupos(:,i))); m(a,1:2)=(sum(Grupos(:,i:i+1)))./(Num(1)); a=a+1;
i = i+2;
end
% Analisis de convergencia
dist_conv = sum((m_anterior-m).^2,2); C = find(dist_conv>0.1,5);
 if size(C) == [0,1]
     flag = 1;
else
i=1;
a=1;
h=1;
m_anterior = m; B=zeros(f,k); Grupos=[];
iteracion= iteracion+1;
end end
Clase=1:1:k;
clasificacion= sum(B.*Clase,2);
figure scatter(Puntos(:,1),Puntos(:,2),50,clasificacion,'o'); hold on
grid on
scatter (m(:,1),m(:,2),'or','LineWidth',5) title('Clases según corrida #2');
hold off
%% Reinicio de iteradores
     i=1;
     a=1;
     h=1;
     m=[];

B=zeros(f,k); Grupos=[];
iteracion= iteracion+1;
%% Tercera corrida
a=1:1:k;
r = randi(f,1,5); m(a,:)=Puntos(r,:);
% Declaracion de variable control e iteraciones
flag =0;
B=zeros(f,k);
clases (Hot****)
h=1;
iteracion = 1;
m_anterior = m;
evaluar su mejora
while flag == 0
while h <= f dist=(m-Puntos(h,:)).^2; dist=sum(dist,2); [M,I]=min(dist); B(h,I)=1;
h=h+1;
end
i=1; a=1;
while i<=2*k
Grupos(:,i:i+1) = B(:,a).* Puntos; a=a+1;
i=i+2;
end
i=1;
a=1;
m=[];
% Calculamos los nuevos centroides
%Inicialicion de variable control de
%Control de iteraciones para presentar %Guarda centroides anteriores para
while i<=k*2
Num=size(find(Grupos(:,i))); m(a,1:2)=(sum(Grupos(:,i:i+1)))./(Num(1)); a=a+1;
i = i+2;
end
% Analisis de convergencia
dist_conv = sum((m_anterior-m).^2,2); C = find(dist_conv>0.1,5);

 if size(C) == [0,1]
     flag = 1;
else
i=1;
a=1;
h=1;
m_anterior = m; B=zeros(f,k); Grupos=[];
iteracion= iteracion+1;
end end
Clase=1:1:k;
clasificacion= sum(B.*Clase,2);
figure scatter(Puntos(:,1),Puntos(:,2),50,clasificacion,'o'); hold on
grid on
scatter (m(:,1),m(:,2),'or','LineWidth',5) title('Clases según corrida #3');
hold off
%% Reinicio de iteradores
i=1;
a=1;
h=1;
m=[];
B=zeros(f,k); Grupos=[];
iteracion= iteracion+1;
%% Sección 2
Imagen=imread('highway.jpg'); figure
subplot(1,2,1); imshow(Imagen)
R=Imagen(:, :, 1);
G=Imagen(:, :, 2);
B=Imagen(:, :, 3); Dataset=double([R(:), G(:), B(:)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aplicamos K_means para agrupar datos utilizando K=3,4,5,6 k = 3;
[f,c]=size(Dataset);
a=1:1:k;
r = randi(f,1,k);
m(a,:)=Dataset(r,:);

% Declaracion de variable control e iteraciones
flag =0;
B=zeros(f,k);
clases (Hot****)
h=1;
iteracion = 1;
m_anterior = m;
evaluar su mejora
while flag == 0
while h <= f dist=(m-Dataset(h,:)).^2; dist=sum(dist,2); [M,I]=min(dist); B(h,I)=1;
h=h+1;
end
i=1; a=1;
%Inicialicion de variable control de
%Control de iteraciones para presentar %Guarda centroides anteriores para
while i<=c*k
Grupos(:,i:i+2) = B(:,a).* Dataset; a=a+1;
i=i+c;
end
i=1;
a=1;
m=[];
% Calculamos los nuevos centroides
while i<=k*c
Num=size(find(Grupos(:,i))); m(a,1:c)=(sum(Grupos(:,i:i+2)))./(Num(1)); a=a+1;
i = i+c;
end
% Analisis de convergencia
dist_conv = sum((m_anterior-m).^2,2); C = find(dist_conv>0.1,k);
 if size(C) == [0,1]
     flag = 1;
else
     i=1;
     a=1;
     h=1;
     m_anterior = m;
     B=zeros(f,k);
     Grupos=[];

iteracion= iteracion+1;
end end
Clase=1:1:k;
clasificacion= sum(B.*Clase,2);
clasificacion=reshape(clasificacion,size(Imagen,1),size(Imagen,2)); m=m/255;
Imagen_clasificada=label2rgb(clasificacion,m);
subplot(1,2,2);
imshow(Imagen_clasificada)
%% Para k = 4
%
figure imshow('k_4.PNG') %
%% Para k = 5
%
figure imshow('k_5.PNG') %
%% Para k = 6
%
figure imshow('k_6.PNG')
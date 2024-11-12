function[Prediccion]=pronostico_delitos2(serie, division, tipo,H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Este algoritmo se le entra datos (serie como vector columna) una serie de tiempo.

%division: es el núemro de periodos que hay en una año. Por ejemplo si la
           %serie es mensual (division =12) si la serie es trimestral
           %division =4
%H:        Es el número de meses hacía adelante que se quiere predecir. Ojo
%si tipo es 1 H debe ser 1


% Tipo: es el suavizado de la serie desestacionalizada 
%         tipo=1: suavizado exponencial
%         tipo=2: tendencia lineal
%         tipo=3: la media de la serie
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%pm:                   Promedios móviles
%pmc:                  Promedios móviles centrados
%Factor_Estacional:    Factor Estacional en la  segunda columna de cada Periódo. ( si la serie es
%                      mensual sería de cada correspondiente mes del año en la segunda columna)
%RealPron:             Matriz de 2 Columnas con los valores Reales de la serie en la primera columna
%                      y Pronosticados e la serie en la segunda columna
%Prediccion:           Predicción de los H meses que se quieren validar.
%ECM                   Error Cuadático Medio sobre en la muestra
%TestJI:               Test chicuadrado sobre la normalidad de los errores de predicción
%p_ValueJI:            Valor p del test chicuadrado de hipótesis de Normalidad.
%TestJB:               Test Jarque-Bera  sobre la normalidad de los errores de predicción
%p_ValueJI:            Valor p del test Jarque-Bera  de hipótesis de Normalidad.
%Parametros_Regresion: Coeficientes de la Regresión Lineal del Pronóstico versus los Datos.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Henry Laniado-Rodas
%Universidad del Cauca
%Noviembre de 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
serieo=serie;
[nf nc]=size(serie);
n=division;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   %sacando el promedio móvil
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:nf-n+1;
    separt=0;
    for i=j:n+j-1
    separt=separt+serie(i);
    end
    pm(j)=separt/n;
end
pm=pm';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     %sacando el promedio móvil centrado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
serie=pm;
[nf nc]=size(serie);
for j=1:nf-2+1
    separt=0;
    for i=j:2+j-1
    separt=separt+serie(i);
    end
    pmc(j)=separt/2;
end
pmc=pmc';
pmcaux=[ones(n/2,1)
    pmc;
    ones(n/2,1)];
vestacional=serieo./pmcaux;
Valor_Estacional=vestacional(n/2+1:end-n/2);
tv=length(Valor_Estacional);
periodo=[1:tv]';
periodo=n/2+periodo;
periodo=mod(periodo,n);
for i=1:tv
    if periodo(i)==0;
        periodo(i)=n;
    end
end
for j=1:tv;
    iest=0;
    k=0;
for i=1:tv
    if periodo(i)==periodo(j);
        k=k+1;
        iest=iest+Valor_Estacional(i);
        
    end
end
indest(j)=iest/k;
end
indest=indest';
Matriz=[periodo Valor_Estacional  indest];

nf2=length(serieo);
periodo2=[1:nf2]';
periodo2=mod(periodo2,n);
for i=1:nf2;
    if periodo2(i)==0;
        periodo2(i)=n;
    end
end
periodo2;

for j=1:tv;
    for i=1:nf2
    if periodo2(i)==periodo(j);
        indest2(i)=indest(j);
              
    end
end
end
indest2=indest2';
ventdesest=serieo./indest2;
Matriz2=[periodo2 serieo indest2 ventdesest];
MesFinal=mod(nf2,12);%creo que hay que cambiar este 12 por division
 if MesFinal==0;
     MesFinal=12; %aquí también
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Factor Estacional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nFE=length(periodo);
FE=indest2(1:nFE);
Factor_Estacional=[periodo FE];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Eligiendo Tendencia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tipo==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%suavizado exponencial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sexp(1)=ventdesest(1);
alpha=0.7;
for i=2:nf2+1
    sexp(i)=sexp(i-1)+alpha*(ventdesest(i-1)-sexp(i-1));
    
end
s=sexp([1:end-1])'.*Matriz2(:,3);
sp=(sexp([end-1:end]))'.*Matriz2([MesFinal:MesFinal+1],3);%pronostico por factor Estacional
else
    if tipo==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%regresion lineal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     X=[ones(nf2,1) [1:nf2]'];

     beta=X\ventdesest;
     sexp=X*beta;
     sexp=sexp';
     s=sexp'.*Matriz2(:,3);
     ump=nf2+H;
     sp=([ones(ump-nf2+1,1) [nf2:ump]']*beta).*Matriz2([MesFinal:MesFinal+H],3);%pronosticoXFE 

    else if tipo==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Media de la Serie.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         sexp=mean(serieo)*ones(nf2,1);
         sexp=sexp';
         s=sexp'.*Matriz2(:,3);
         sp=mean(serieo).*Matriz2([MesFinal:MesFinal+H],3);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Serie Real Pronóstico sobre la muestra y Predicción fuera de la muetra
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealPron=[serieo s];
Prediccion=sp;
seriedesest=ventdesest; %sólo pa' Temperaturas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Gráficos Se borran Mintras tanto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
%  subplot(2,1,1)
%  grid
%  hold on
%  plot(seriedesest,'LineWidth',1);
%  hold on
% plot(seriedesest,'o','LineWidth',1);
%  legend('Delitos Desestacionalizados')
%  xlabel('Meses','fontsize',15,'fontweight','b')
%  hold on
%  subplot(2,1,2)
%  grid
% plot(serieo,'r','LineWidth',1);
%  hold on
%  plot(serieo,'o r','LineWidth',1);
%  legend('Delitos')
%  xlabel('Meses','fontsize',15,'fontweight','b')
%  hold on
%  figure
%  subplot(2,1,1)
%  grid
%  hold on
%  plot(ventdesest,'LineWidth',1);
%  hold on
%  plot(sexp,'m','LineWidth',1);
%  hold on
%  %plot(ventdesest,'o','LineWidth',1);
%  %plot(sexp,'o m','LineWidth',1);
%  legend('Delitos Desestacionalizados','Suavizado Exponencial')
%  xlabel('Meses','fontsize',15,'fontweight','b')
% % %xlabel('Meses desde Enero de 2008 hasta Diciembre de 2010','fontsize',15,'fontweight','b')
%  ylabel('Delitos Desestacionalizados','fontsize',15,'fontweight','b')
%  subplot(2,1,2)
%  grid
%  plot(serieo,'LineWidth',1);
%  xlabel('Meses','fontsize',15,'fontweight','b')
%  ylabel('Delitos','fontsize',15,'fontweight','b')
% hold on
% plot(s,'r','LineWidth',1);
% % hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Para tipo 1 sólo esposible una predicción. Mientras que para tipo 2 es
%posible H prediciones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tipo==1
    F=nf2+1;
end
if ((tipo==2)| (tipo==3))
    F=nf2+H;
end
 %plot([nf2:F],sp,'k','LineWidth',1);
%legend('Time serie','Prediction', 'Forecast',15,'fontweight','b')
% hold on
 %plot(serieo,'o','LineWidth',1);
%hold on
%plot(s,'o r','LineWidth',1);
% hold on
% grid
% plot([nf2:F],sp,'o k','LineWidth',1);
% xlabel('Meses','fontsize',15,'fontweight','b')
% %xlabel('Meses desde Enero de 2008 hasta Diciembre de 2011','fontsize',15,'fontweight','b')
% ylabel('Delitos','fontsize',15,'fontweight','b')
% legend('Delitos','Predicción', 'Pronóstico')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Analisis de Errores de predicción
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Errores=RealPron(:,1)-RealPron(:,2);
P = polyfit(RealPron(:,1),RealPron(:,2),1);
Y = polyval(P,RealPron(:,1));
Parametros_Regresion=P;
%figure
% subplot(2,1,1)
% hist(Errores)
% title('Prediction errors','fontsize',15,'fontweight','b')
% subplot(2,1,2)
% grid
% plot(RealPron(:,1),RealPron(:,2),'o b','LineWidth',1);
% hold on
% grid
% plot(RealPron(:,1),Y,'r','LineWidth',1);
% xlabel('Data','fontsize',15,'fontweight','b')
% ylabel('Predicción','fontsize',15,'fontweight','b')
% ECM=var(Errores)*length(Errores);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test chi square for Normality
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [h,p] = chi2gof(Errores); %test chi square for Normality
% [hjb,pjb] = jbtest(Errores);%test Jarque-Bera for Normality
% P_ValueJI =p;
% if h==0
%    TestJI= 'Se acepta Normalidad sobre los Residuos';
% 
% else
%    TestJI= 'No se acepta Normalidad sobre los Residuos';
% 
% end
% P_ValueJB =pjb;
% if hjb==0
%    TestJB= 'Se acepta Normalidad sobre los Residuos';
% 
% else
%    TestJB= 'No se acepta Normalidad sobre los Residuos';
% 
% end




        


    
    
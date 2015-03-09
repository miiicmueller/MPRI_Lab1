clear;home;close all ;
format short g;
rng('default');



% Ouverture des 2 fichiers de données
user = fopen('TP01-1-genuine.txt');
impost = fopen('TP01-1-impostures.txt');

% Lecture des données
[user_score,user_score_count] = fscanf(user,'%f\r\n');
[imp_score,imp_score_count] = fscanf(impost,'%f\r\n');


% Données qui peuvent être utiles
min_score_user = min(user_score);
max_score_user = max(user_score);

min_score_imp = min(imp_score);
max_score_imp = max(imp_score);

% Creation de l'histogramme
figure(1);
subplot(1,2,1);
hist(user_score);
axis square;
title('Histogramme de score Genuine');
xlabel('Classes');
ylabel('Nombres d''echantillons');


subplot(1,2,2);
hist(imp_score);
axis square;
title('Histogramme de score imposteurs');
xlabel('Classes');
ylabel('Nombres d''echantillons');



% Comptage de fausse rejection(FR)
FR_Array = 0:((max_score_user+1.1)/0.1);

% Comptage de fausse acceptation(FA)
FA_Array = 0:((max_score_user+1.1)/0.1);

ind = 0;


for T = -1.1:0.1:max_score_user
    
    FR = 0;
    FA = 0;
    
    ind= ind + 1;
    for u = 1:user_score_count
  
        if(user_score(u) <= T)
            FR = FR + 1 ;
        end
    end 

    for imp = 1:imp_score_count
  
        if(imp_score(imp) > T)
            FA = FA + 1 ;
        end
    end 

    FR_Array(ind) = (FR/user_score_count)*100
    FA_Array(ind) = (FA/imp_score_count)*100
    
end

% Tacage du graphique FA/FR
figure(2);
plot(-1.1:0.1:max_score_user,FR_Array,-1.1:0.1:max_score_user,FA_Array);
axis square;
axis([-1.09 11.03 0 100]);
grid on;
title('FR(T) & FA(T)');
xlabel('Valeur de T');
ylabel('Taux de FR(t) et FA(T) en %');
legend('FR(T)','FA(T)');

% Tacage du graphique ROC
figure(3);
plot(FA_Array,FR_Array);
axis square;
grid on;
title('Diagramme ROC');
xlabel('Fausse acceptation en %');
ylabel('Fausse rejection en %');
legend('ROC');

% Tacage du graphique DET
figure(4);
loglog(FA_Array,FR_Array);
axis square;
axis([0 50 0 50]);
grid on;
title('Diagramme DET');
xlabel('Fausse acceptation en %');
ylabel('Fausse rejection en %');
legend('DET');


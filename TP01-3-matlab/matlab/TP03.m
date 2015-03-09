clear;home;close all ;
format short g;
rng('default');

path = '/home/DarkOne/Master/MPRI/TP01/TP01-3-matlab/Voix/' ;
name_prefix = 'MICHAEL-';

other_prefix = [{'CASAS-'};{'CORNAZ-'};{'DROGUET-'}; {'FRANK-'};{'MONNEY-'};{'Rossier-'};{'SILVA-'}];

file_num = '';

% Exctraction des données sonores MICHAEL
for i= 1:1:50
   
    file_num = sprintf('%02d',i);    
    full_path = [path name_prefix file_num];
    FeatureGeneratorTxt(full_path);

end

% Exctraction des données sonores : OTHERs
[om on] = size(other_prefix);
for i = 1:1:om
    for j= 1:1:50
   
        file_num = sprintf('%03d',j);    
        full_path = [path char(other_prefix(i)) file_num];
        FeatureGeneratorTxt(full_path);
    end
end

% Récuperation des données extraites
training_set = [];
target_set = [];
 
% On prend les 40 premiers fichier pour entrainer le système

% MICHAEL
for i= 1:1:40
    file_num = sprintf('%02d',i);    
    full_path = [path name_prefix file_num];
    features = csvread([full_path '.txt']);
    training_set = [training_set ; features(:,1:5)];
    [m,n] = size(features(:,1:5));
    
    target_set = [target_set ; ones([m 1])];
end

% OTHERs
[om on] = size(other_prefix);
for i = 1:1:om
    for j= 1:1:40
        file_num = sprintf('%03d',j);    
        full_path = [path char(other_prefix(i)) file_num];
        features = csvread([full_path '.txt']);
        training_set = [training_set ; features(:,1:5)];
        [m,n] = size(features(:,1:5));
    
        target_set = [target_set ; zeros([m 1])];
    end
end

net = feedforwardnet(3);
net = train(net,training_set',target_set');
view(net);

% On valide notre système, avec 2 set (avec les dernier 10 autres fichiers wav)
michael_set = [];
other_set = [];
ctrl_set = [];
michael_score = [];
other_score = [];

% MICHAEL
for i= 41:1:50
    file_num = sprintf('%02d',i);    
    full_path = [path name_prefix file_num];
    features = csvread([full_path '.txt']);
    michael_set = features(:,1:5);
    
    % On calcul notre score
    michael_score = [michael_score; [sum(net(michael_set'))]];
end

% OTHERs
[om on] = size(other_prefix);
for i = 1:1:om
    for j= 41:1:50
        file_num = sprintf('%03d',41);    
        full_path = [path char(other_prefix(i)) file_num];
        features = csvread([full_path '.txt']);
        other_set =  features(:,1:5);
        other_score = [other_score ; [sum(net(other_set'))]];
    end
end


% Create DET

[user_score_count, dummy] = size(michael_score);
[imp_score_count, dummy] = size(other_score);


% Données qui peuvent être utiles
min_score_user = min(michael_score);
max_score_user = max(michael_score);

min_score_imp = min(other_score);
max_score_imp = max(other_score);

% Creation de l'histogramme
figure(1);
subplot(1,2,1);
hist(michael_score);
title('Histogramme de score Genuine');
xlabel('Classes');
ylabel('Nombres d''echantillons');


subplot(1,2,2);
hist(other_score);
title('Histogramme de score imposteurs');
xlabel('Classes');
ylabel('Nombres d''echantillons');



% Comptage de fausse rejection(FR)
FR_Array = 0:((max_score_user)/0.1);

% Comptage de fausse acceptation(FA)
FA_Array = 0:((max_score_user)/0.1);

ind = 0;


for T = 0:0.1:max_score_user
    
    FR = 0;
    FA = 0;
    
    ind= ind + 1;
    for u = 1:user_score_count
  
        if(michael_score(u) <= T)
            FR = FR + 1 ;
        end
    end 

    for imp = 1:imp_score_count
  
        if(other_score(imp) > T)
            FA = FA + 1 ;
        end
    end 

    FR_Array(ind) = (FR/user_score_count)*100;
    FA_Array(ind) = (FA/imp_score_count)*100;
    
end

% Tacage du graphique FA/FR
figure(2);
subplot(3,1,1);
plot(0:0.1:max_score_user,FR_Array,0:0.1:max_score_user,FA_Array);
grid on;
title('FR(T) & FA(T)');
xlabel('Valeur de T');
ylabel('Taux de FR(t) et FA(T) en %');
legend('FR(T)','FA(T)');

% Tacage du graphique ROC
subplot(3,1,2);
plot(FA_Array,FR_Array);
grid on;
title('Diagramme ROC');
xlabel('Fausse acceptation en %');
ylabel('Fausse rejection en %');
legend('ROC');

% Tacage du graphique DET
subplot(3,1,3);
loglog(FA_Array,FR_Array);
grid on;
title('Diagramme DET');
xlabel('Fausse acceptation en %');
ylabel('Fausse rejection en %');
legend('DET');





clear;home;close all ;
format short g;
rng('default');

x_train = [0:0.1:2*pi] ;
y_target = cos(x_train);

net = feedforwardnet(3);
net10 = feedforwardnet(10);

net = train(net,x_train,y_target);
net10 = train(net10,x_train,y_target);

view(net);

% Prenons une valeur de x qui n'appartient pas au set

x_validation = [0:0.03:2*pi];

y = net(x_validation);
y10 = net10(x_validation);

figure(1);
subplot(2,1,1);
plot(x_train,y_target,x_validation,y);
title('Train set vs Validation set');
xlabel('input value');
ylabel('output value');
legend('Cos(x)','ANN output');

subplot(2,1,2);
plot(x_validation,cos(x_validation)-y,x_validation,cos(x_validation)-y10);
title('ANN error output');
xlabel('input value');
ylabel('output error');
legend('Error 3-layer ANN','Error 10-layer ANN');



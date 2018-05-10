% Example of extracting ANN equation from Matlab
% (In future may use this to test partial derivative code with known
% equations and derivatives)
% Loren Albert, 2014


% Useful links:
% http://www.mathworks.com/help/nnet/ug/multilayer-neural-network-architecture.html
% https://www.mathworks.com/matlabcentral/newsreader/view_thread/318575
% https://groups.google.com/forum/?hl=en#!msg/comp.soft-sys.matlab/aTwCWGlCvSE/WldZKbn8JA0J
% http://mathinsight.org/partial_derivative_examples
% http://www.mathworks.com/help/symbolic/differentiation.html
% http://www.mathworks.com/matlabcentral/answers/127061-low-performance-of-neural-network-using-logsig-for-output-layer
% http://umseee.weebly.com/uploads/9/3/5/8/9358123/_lec_2b_-_bp_net_gray_.pdf

clear all

%% Define a simple equation (and calculate partial derivatives)

syms x y
f = y*x^2;
dfdx=diff(f,x);
dfdy=diff(f,y);

% % Now I want to define a vector of X values, Y values and f(x,y) values.
% % The X and Y vectors will be ANN inputs.  The f(x,y) will be the ANN target.
% One way to make the matrices: Z1 = Y1.*X1.^2;
X=[(1:10),(ones(1,10)),(1:10),(1:10),(repmat(2,1,10)),(repmat(5,1,10)),(1:10),(1:10),(repmat(7,1,10)),(repmat(10,1,10)),(1:10)];
Y=[(1:10),(1:10),(ones(1,10)),(repmat(2,1,10)),(1:10),(1:10),(repmat(5,1,10)),(repmat(7,1,10)),(1:10),(1:10),(repmat(10,1,10))];
% Make a matlab function from the symbolic function
matlabFunction(f, 'file', 'test_function',...
'vars', [x y]);
Z=test_function(X,Y); % To have a simple name, let Z = f(x,y)
inputs=[X;Y];


%% Run ANN

% The main change from defaults here is using only 3 hidden nodes.  There
% is code commented out showing how to change the transfer functions.

inputs = inputs;
targets = Z;

% Create a Fitting Network
hiddenLayerSize = 3;
net = fitnet(hiddenLayerSize);
% % Can change the transfer functions using the commands below, but if I use
% % Logsig I think I also need to change the pre-processing so data is scaled
% % from 0 to 1 instead of -1 to 1?
% net.layers{1}.transferFcn = 'logsig';
% net.layers{2}.transferFcn = 'purelin';

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);
valPerformance = perform(net,valTargets,outputs);
testPerformance = perform(net,testTargets,outputs);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotfit(net,inputs,targets)
%figure, plotregression(targets,outputs)
%figure, ploterrhist(errors)

% See network simulated outputs given inputs
net_sim=sim(net,inputs);



%% Extract information from Matlab ANN and write ANN equation

% % Useful commands for learning about network
% net
% net.numLayers
% net.layers(1).dimensions
% net.numInputs

% Double check transfer functions for the two layers
net.layers{1}.transferFcn
net.layers{2}.transferFcn

% Extract the weights and biases for use with ann equation
% Matlab says:
%  'The weight matrix for the weight going to the ith layer from the jth
%  layer (or a null matrix []) is located at net.LW{i,j} if
%  net.layerConnect(i,j) is 1 (or 0).' (help for NET.LW)
W1=net.IW{1,1};
W2=net.LW{2,1};
B1=net.b{1};
B2=net.b{2};

% Scale data from -1 to 1 (or 0 to 1 if logsig?) for use with ann equation
in_min=min(inputs);
in_max=max(inputs);
[in_squashed,PS] = mapminmax(inputs); %Can also use equation: xn = -1+ 2*(inputs-in_min)/(in_max-in_min) ;

% Put together pieces to make net equation
first_layer = tansig(W1*in_squashed+B1*ones(1,size(inputs,2)));
net_eq = W2*first_layer+B2;


% Reverse the processing from -1 to 1 to min and max of targets
% mapminmax(yn,tmin,tmax)
% Should also be able to use something like this but gives wrong result: mapminmax(net_eq,T_min,T_max);
T_min=min(targets);
T_max=max(targets);
net_eq_test = T_min +(T_max-T_min)*(net_eq +1)/2;



%% Plots of f(x,y) and net inputs versus outputs
% These plots should all look very similar since network is trained on the
% f(x, y).

% Look at MSE of Matlab network output and equation output
MSE = mse(net_sim-net_eq_test);

% Plots of the function f (trying to simulate this with network)
figure(1)
ezsurf(f,[0 10 0 10])

% Plots of net inputs (X, Y) and outputs (net_eq_test or net_sim, which should look very similar)
figure(2)
[xq,yq] = meshgrid(1:1:10, 1:1:10);
% vq = griddata(X,Y,net_eq_test,xq,yq);
% mesh(xq,yq,vq);
% hold on
% plot3(X,Y,net_eq_test,'o');
vq = griddata(X,Y,net_sim,xq,yq);
mesh(xq,yq,vq);
hold on
plot3(X,Y,net_sim,'o');

